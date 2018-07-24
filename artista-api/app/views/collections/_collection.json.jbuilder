json.extract! _collection, :id, :name, :user_id, :created_at, :updated_at
json.workspace_image_url rails_blob_url(_collection.workspace_image) if _collection.workspace_image.attached?
