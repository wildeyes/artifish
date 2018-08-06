require "base_provider"

module SearchProviders
  class PhotoArt < BaseProvider
    PRICE_CURRENCY = "ILS"
    CACHE_PRICE = true
    SUPPLIER_NAME = "photo_art"
    BASE_URL = "https://www.photo-art.co.il/"
    URL = "#{BASE_URL}%s"
    CATEGORIES = {
      :urban => 'photosc/urban',
      :nature => ["photosc/landscape", "photosk/%D7%99%D7%A8%D7%95%D7%A7-%D7%A4%D7%A8%D7%90%D7%99", "photosc/nature", "photosk/panoramic", "photosk/%D7%A1%D7%AA%D7%99%D7%95", "photosc/%D7%A4%D7%99%D7%A1%D7%95%D7%9C-%D7%91%D7%90%D7%91%D7%9F"],
      :water => ["photosk/%D7%AA%D7%AA-%D7%99%D7%9E%D7%99", "photosc/sea"],
      :flowers => ["photosc/flowers", "photosk/%D7%A4%D7%A8%D7%97%D7%99%D7%9D-%D7%A2%D7%9C-%D7%9C%D7%91%D7%9F", "photosk/%D7%90%D7%91%D7%99%D7%91"],
      :childhood => 'photosk/childrens-room',
      :humanity => ["photosk/%D7%A2%D7%99%D7%A8%D7%95%D7%9D", "photosc/people"],
      :abstract => ["photosc/abstract", "photosc/still-life", "photosk/photos-for-dining-room"]
    }

    def initialize
      super
    end

    protected

    def url(category_identifier)
      URL % category_identifier.to_s
    end

    def get_linked_images_hashes(page)
      products_list_items = page.css('ul.products').css('li.product')
      linked_images = []
      products_list_items.each do |list_item|
        url_link = get_link(list_item.css('.inbox.ev').css('a').first[:href])
        catalog_num = url_link.split('/').last
        image_hash = {
          :image_url => get_link(list_item.css('.image-link').css('img').first[:src]),
          :url_link => url_link,
          :name => list_item.css('.inbox.ev').css('span.caption').text.strip,
          :catalog_num => catalog_num
        }
        linked_images << image_hash
      end
      linked_images
    end

    def get_next_page_link(page)
      next_page_a_tag = page.css('ul.page-numbers').css('a.next.page-numbers').first
      if next_page_a_tag && next_page_a_tag[:href]
        next_page_link = get_link next_page_a_tag[:href]
      end
      next_page_link
    end

    def get_materials_with_sizes(page)
      # REMOVE THIS CODE WHEN NOT LIMITED ONLY TO JACKIE'S PHOTOS
      photographer = page.css('div.product_meta').css('p').last.text
      puts "Could not find photographer for photo #{page.css('h1.product_title').last.text}" if !photographer.include?('צלם')
      return nil if !photographer.include?('צלם')
      return nil if !photographer.include?("ג'קי סויקיס")
      # END OF REMOVE
      sections = page.css('div.cpf-section[data-logic]').reject{|x| !x['data-logic'].present?}
      materials_with_sizes = sections.map do |section|
        next if section.css('div.cpf-type-select').last.nil?
        selects = section.css('div.cpf-type-select div.tm-extra-product-options-container select').reject{|s| s.css("option").first['data-imagep'].present?}
        options = selects.last.css('option')
        sizes = options.map { |opt| opt['data-text'] }

        data_logic = JSON.parse(section['data-logic'])
        {
          material_id: section['data-uniqid'],
          material_name: URI.decode(data_logic['rules'].first['value']),
          sizes: sizes
        }
      end.compact
      materials_with_sizes
    end

    def get_price(page, material_id, w, h)
      if !@base_price
        p = page.css('div.summary.entry-summary').css('p.price')
        amount = p.css('ins').css('span.woocommerce-Price-amount.amount')
        amount = p.css('span.woocommerce-Price-amount.amount') unless amount.present?
        @base_price = /[\d\.]+/.match(amount.text.gsub(',', '')).to_s.to_f
      end
      section = page.css("div.cpf-section[data-uniqid='#{material_id}']")
      selects = section.css('div.cpf-type-select div.tm-extra-product-options-container select').reject{|s| s.css("option").first['data-imagep'].present?}
      option = selects.last.css("option[data-text='#{w}X#{h}']").first || selects.last.css("option[data-text='#{w}x#{h}']").first
      puts selects.last.inner_html if option.nil?
      puts "data-text='#{w}x#{h}'" if option.nil?
      data_price = option['data-price'].to_f
      @base_price + data_price
    end

    def get_image_full_size(page)
      page.css('div.woocommerce-product-gallery__image').first['data-thumb']
    end
  end
end
