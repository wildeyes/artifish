class CreateOrderItems < ActiveRecord::Migration[5.2]
  def change
    create_table :order_items do |t|
      t.string :name
      t.string :image_link
      t.string :url_link
      t.monetize :price
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
