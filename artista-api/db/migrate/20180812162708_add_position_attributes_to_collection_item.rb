class AddPositionAttributesToCollectionItem < ActiveRecord::Migration[5.2]
  def change
    add_column :collection_items, :position_attributes, :text
  end
end
