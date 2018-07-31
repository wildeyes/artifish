require "base_provider"
require "galmir_allowed_catalogs"

module SearchProviders
  class Galmir < BaseProvider
    CACHE_PRICE = true
    SUPPLIER_NAME = "galmir"
    BASE_URL = "http://www.galmir.co.il/"
    URL = "#{BASE_URL}result.asp?rootcat=749&cat_id=%s&parent=749"
    GET_PRICE_AJAX_URL = "http://www.galmir.co.il/ajax/calculateP.asp?w=%s&h=%s&q=1&material=%s&id=%s"
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

    def initialize
      super
    end

    protected

    def url(category_identifier)
      URL % category_identifier.to_s
    end

    def get_linked_images_hashes(page)
      item_tables = page.css('.item')
      linked_images = []
      item_tables.each do |item_table|
        url_link = get_link(item_table.css('.item-category-name').css('a').first[:href])
        catalog_num = item_table.css('.item-catalognum').first.text.gsub(/\u00a0/, '')
        # skip item if catalog number is not in the allowed list
        # next if should_skip_image({url_link: url_link, catalog_num: catalog_num})
        image_hash = {
          :image_url => get_link(item_table.css('.item-zoom').css('a').first[:href]),
          # :thumb_image_url => get_link(item_table.css('.item-pic').css('img').first[:src]),
          :url_link => url_link,
          :name => item_table.css('.item-title').css('a').first.text,
          :catalog_num => catalog_num
        }
        linked_images << image_hash
      end
      linked_images
    end

    def get_next_page_link(page)
      next_page_a_tag = page.css('.padding-next[align=left] > a').first
      if next_page_a_tag && next_page_a_tag[:href]
        next_page_link = get_link next_page_a_tag[:href]
      end
      next_page_link
    end

    def get_sizes_hash(page)
      page.css('select[name=canvassize]').first.css('option').map { |size_opt| size_opt[:value] }.uniq
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

    def get_price(page, material_id, w, h)
      product_id = page.css('div.framing-tabs').css('input[name=id]').first[:value]
      response = HTTParty.get(GET_PRICE_AJAX_URL % [w, h, material_id, product_id])
      price = /[\d\.]+/.match(response.body).to_s
      price
    end
  end
end
