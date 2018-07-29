if collection_item.portfolio_item_id.present?
  json.extract! collection_item, :id, :portfolio_item_id, :collection_id
  json.extract! collection_item.portfolio_item, :name, :created_at, :updated_at
  json.image_url rails_blob_url(collection_item.portfolio_item.image) if collection_item.portfolio_item.image.attached?
  json.purchase_options collection_item.portfolio_item.purchase_options_formatted do |material_id, purchase_options|
    json.material_id material_id
    json.material purchase_options.first.material.name
    json.prices purchase_options do |purchase_option|
      json.size_id purchase_option.size_id
      json.size purchase_option.size.name
      json.extract! purchase_option, :id, :price_cents
      json.price_formatted purchase_option.price.format
      json.currency_code purchase_option.price.currency.iso_code
    end
  end
else
  json.extract! collection_item, :id, :portfolio_item_id, :name, :image_url, :item_url, :collection_id, :price_cents, :created_at, :updated_at
  json.price_formatted collection_item.price.format
  json.currency_code collection_item.price.currency.iso_code
end
