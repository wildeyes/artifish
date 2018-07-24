json.partial! "collections/collection", _collection: @collection
json.items @collection.items, partial: 'collection_items/collection_item', as: :collection_item
