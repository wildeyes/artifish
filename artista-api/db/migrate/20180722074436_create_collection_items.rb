class CreateCollectionItems < ActiveRecord::Migration[5.2]
  def change
    create_table :collection_items do |t|
      t.string :name
      t.string :image_link
      t.string :url_link
      t.monetize :price
      t.references :collection, foreign_key: true

      t.timestamps
    end
  end
end
