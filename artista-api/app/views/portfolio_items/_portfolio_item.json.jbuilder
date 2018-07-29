# json.extract! portfolio_item, :created_at, :updated_at
json.portfolio_item_id portfolio_item.id
json.image_url rails_blob_url(portfolio_item.image) if portfolio_item.image.attached?
json.colors portfolio_item.colors.map(&:to_hex)
