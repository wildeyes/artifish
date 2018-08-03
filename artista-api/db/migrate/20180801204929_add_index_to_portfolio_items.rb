class AddIndexToPortfolioItems < ActiveRecord::Migration[5.2]
  def change
    add_index :portfolio_items, [:supplier_id, :product_identifier], unique: true
  end
end
