json.extract! collection_item, :id, :name, :image_link, :url_link, :collection_id, :price_cents, :created_at, :updated_at
json.price_formatted collection_item.price.format
json.currency_code collection_item.price.currency.iso_code
