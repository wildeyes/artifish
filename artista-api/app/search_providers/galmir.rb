require "galmir_allowed_catalogs"

module SearchProviders
  class Galmir
    SUPPLIER_NAME = "galmir"
    BASE_URL = "http://www.galmir.co.il/"
    URL = "#{BASE_URL}result.asp?rootcat=749&cat_id=%s&parent=749"
    GET_PRICE_URL = "http://www.galmir.co.il/ajax/calculateP.asp?w=%s&h=%s&q=1&material=%s&id=%s"
    CATEGORIES = {
      :pop_art => 897,
      :urban => 752,
      :nature => 832,
      :animals => 751,
      :kids => 859,
      :movies_and_tv => 937,
      :music => 938,
      :commercials => 838
    }
    ALLOWED_MATERIALS_IDS = [2, 1]
    TEMP_IMAGES_DIR = "#{Rails.root}/tmp/images"

    def initialize
      @material_cache ||= {}
      @size_cache ||= {}
      @pricing_cache = {}
      @already_loaded_portfolios = {}
      get_or_create_supplier
      PortfolioItem.where(supplier_id: @supplier_id).pluck(:product_url).each { |url| @already_loaded_portfolios[url] = true }
      FileUtils.mkdir_p(TEMP_IMAGES_DIR) unless File.directory?(TEMP_IMAGES_DIR)
    end

    def run
      categories = [:pop_art, :nature]
      categories.each do |category_name|
        @category_name = category_name
        category = CATEGORIES[@category_name]
        linked_images = build_linked_image_hashes(url(category))
        load_images_to_db(linked_images)
      end
      nil
    end

    private

    def url(category)
      URL % category.to_s
    end

    def build_linked_image_hashes(page_url)
      linked_images = []
      while page_url
        puts "Processing page: #{page_url}"
        start_time = Time.now
        page_linked_images, page_url = get_page_linked_images_and_next_page(page_url)
        puts "Done Processing page in #{Time.now - start_time} seconds"
        linked_images += page_linked_images
        break # TODO: Remove
      end
      puts "Built #{linked_images.count} image hashes"
      linked_images
    end

    def load_images_to_db(linked_images)
      count = 1
      total_count = linked_images.count
      puts "Loading data to db"
      linked_images.each do |image_hash|
        puts "#{count}/#{total_count}: Working on item #{image_hash[:catalog_num]}"
        p = PortfolioItem.new({
          name: image_hash[:name],
          product_identifier: image_hash[:catalog_num],
          product_url: image_hash[:url_link],
          supplier_id: @supplier_id
        })
        p.tags << Tag.find_or_create_by(name: @category_name)
        p.save!
        attach_image(p, image_hash[:image_url])
        create_purchase_options(p, image_hash[:pricing])
      end
    end

    def get_or_create_supplier
      @supplier_id = Supplier.find_or_create_by!(name: SUPPLIER_NAME).id
    end

    def download_image(image_url)
      filename = image_url.split('/').last
      full_path = "#{Rails.root}/tmp/images/#{filename}"
      File.open(full_path, "wb") do |f|
        f.write HTTParty.get(image_url).body
      end
      {full_path: full_path, filename: filename}
    end

    def get_page_linked_images_and_next_page(url)
      c = 0
      response = HTTParty.get(url)
      page = Nokogiri::HTML(response.body)
      item_tables = page.css('.item')
      linked_images = []
      item_tables.each do |item_table|
        url_link = get_link(item_table.css('.item-category-name').css('a').first[:href])
        catalog_num = item_table.css('.item-catalognum').first.text.gsub(/\u00a0/, '')
        # skip item if catalog number is not in the allowed list
        next if should_skip_image({url_link: url_link, catalog_num: catalog_num})
        image_hash = {
          :image_url => get_link(item_table.css('.item-zoom').css('a').first[:href]),
          # :thumb_image_url => get_link(item_table.css('.item-pic').css('img').first[:src]),
          :url_link => url_link,
          :name => item_table.css('.item-title').css('a').first.text,
          :catalog_num => catalog_num
        }
        puts "-- Getting pricing"
        image_hash[:pricing] = get_prices_hash_for_product(url_link)
        linked_images << image_hash
        c += 1
        break if c == 3 # TODO Remove this
      end
      next_page_a_tag = page.css('.padding-next[align=left] > a').first
      if next_page_a_tag && next_page_a_tag[:href]
        next_page_link = get_link next_page_a_tag[:href]
      end
      [linked_images, next_page_link]
    end

    def get_prices_hash_for_product(url)
      pricing = []

      response = HTTParty.get(url)
      page = Nokogiri::HTML(response.body)
      product_id = page.css('div.framing-tabs').css('input[name=id]').first[:value]
      sizes = page.css('select[name=canvassize]').first.css('option').map { |size_opt| size_opt[:value] }.uniq
      material_labels = page.css('li.c3').css('label')
      materials = material_labels.map do |ml|
        {
          material_id: ml.css('input').first[:value].to_i,
          material_name: ml.text.gsub(/\u00a0/, '').strip
        }
      end
      materials.reject! {|m_hash| !ALLOWED_MATERIALS_IDS.include?(m_hash[:material_id])}
      materials.each do |m_hash|
        sizes.each do |size|
          w, h = size.split('x')
          material_id = m_hash[:material_id]
          if @pricing_cache[material_id].present? && @pricing_cache[material_id]["#{w}x#{h}"].present?
            pricing << {
              material_id: material_id,
              material_name: m_hash[:material_name],
              size_w: w.to_i,
              size_h: h.to_i,
              price: @pricing_cache[material_id]["#{w}x#{h}"]
            }
            next
          end
          response = HTTParty.get(GET_PRICE_URL % [w, h, material_id, product_id])
          price = /[\d\.]+/.match(response.body).to_s
          @pricing_cache[material_id] ||= {}
          @pricing_cache[material_id]["#{w}x#{h}"] = price
          pricing << {
            material_id: material_id,
            material_name: m_hash[:material_name],
            size_w: w.to_i,
            size_h: h.to_i,
            price: price
          }
        end
      end
      pricing
    end

    def attach_image(portfolio_item, image_url)
      path_info = download_image(image_url)
      portfolio_item.image.attach(io: File.open(path_info[:full_path]), filename: path_info[:filename])
      FileUtils.rm(path_info[:full_path])
    end

    def create_purchase_options(portfolio_item, pricing_list)
      purchase_options_models = []
      pricing_list.each do |pricing|
        material = @material_cache[pricing[:material_name]]
        if material.nil?
          material = Material.find_or_create_by!(name: pricing[:material_name])
          @material_cache[pricing[:material_name]] = material
        end

        size_name = "#{pricing[:size_w]}x#{pricing[:size_h]}"
        size = @size_cache[size_name]
        if size.nil?
          size = Size.find_or_create_by!(name: size_name)
          @size_cache[size_name] = size
        end

        purchase_options_models << PurchaseOption.new(material_id: material.id, size_id: size.id, portfolio_item_id: portfolio_item.id, price: pricing[:price], price_currency: "ILS")
      end
      # PurchaseOption.import(purchase_options_models)
      PurchaseOption.transaction do
        purchase_options_models.each { |p| p.save! }
      end
    end

    def get_link(link)
      link = "#{BASE_URL}#{link}" if !link.start_with?('http')
      link
    end

    def should_skip_image(attributes={})
      unless ALLOWED_CATALOGS[@category_name][attributes[:catalog_num]]
        puts "Skipping item with not allowed catalog number (#{catalog_num})"
        return true
      end

      unless @already_loaded_portfolios[attributes[:url_link]]
        byebug
        puts "Skipping already loaded item"
        return true
      end

      false
    end
  end
end
