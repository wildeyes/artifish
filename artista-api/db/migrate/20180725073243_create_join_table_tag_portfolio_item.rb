class CreateJoinTableTagPortfolioItem < ActiveRecord::Migration[5.2]
  def change
    create_join_table :tags, :portfolio_items do |t|
      t.index [:tag_id, :portfolio_item_id]
      t.index [:portfolio_item_id, :tag_id]
    end
  end
end
