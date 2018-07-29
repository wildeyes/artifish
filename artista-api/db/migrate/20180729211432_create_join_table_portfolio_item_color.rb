class CreateJoinTablePortfolioItemColor < ActiveRecord::Migration[5.2]
  def change
    create_join_table :portfolio_items, :colors do |t|
      t.index [:portfolio_item_id, :color_id], unique: true
      t.index [:color_id, :portfolio_item_id]
    end
  end
end
