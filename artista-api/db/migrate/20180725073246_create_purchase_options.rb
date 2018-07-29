class CreatePurchaseOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :purchase_options do |t|
      t.references :material, foreign_key: true
      t.references :size, foreign_key: true
      t.references :portfolio_item, foreign_key: true
      t.monetize :price, null: false

      t.timestamps
    end
  end
end
