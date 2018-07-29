class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.string :name
      t.string :image_url
      t.string :item_url
      t.references :purchase_option, foreign_key: true
      t.monetize :price
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
