require "base_provider"

module SearchProviders
  class PhotoArt < BaseProvider
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
      :abstract => ["photosc/urban", "photosc/still-life", "photosk/photos-for-dining-room"]
    }
    ALLOWED_MATERIALS_IDS = [2, 1]

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
        # next if should_skip_image({url_link: url_link, catalog_num: catalog_num})
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
      byebug
      next_page_a_tag = page.css('ul.page-numbers').css('a.next.page-numbers').first
      if next_page_a_tag && next_page_a_tag[:href]
        next_page_link = get_link next_page_a_tag[:href]
      end
      next_page_link
    end

    def get_sizes_hash(page)
      # page.css('div.tm-extra-product-options-container').css('li').css('input[type=radio]')  'select[name=canvassize]').first.css('option').map { |size_opt| size_opt[:value] }.uniq
    end

    def get_materials_hash(page)
      material_labels = page.css('li.c3').css('label')
      materials = material_labels.map do |ml|
        {
          material_id: ml.css('input').first[:value].to_i,
          material_name: ml.text.gsub(/\u00a0/, '').strip
        }
      end
      materials
    end

    def get_price(page)
      response = HTTParty.get(GET_PRICE_URL % [w, h, material_id, product_id])
      price = /[\d\.]+/.match(response.body).to_s
    end
  end
end
