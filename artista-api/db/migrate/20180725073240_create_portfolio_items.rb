class CreatePortfolioItems < ActiveRecord::Migration[5.2]
  def change
    create_table :portfolio_items do |t|
      t.string :name
      t.string :product_identifier
      t.string :product_url
      t.references :supplier, foreign_key: true

      t.timestamps
    end
  end
end
