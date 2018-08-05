class AddIdAndDominanceToPortfolioItemColors < ActiveRecord::Migration[5.2]
  def change
    rename_table :colors_portfolio_items, :portfolio_item_colors
    add_column :portfolio_item_colors, :id, :primary_key
    add_column :portfolio_item_colors, :dominance_index, :integer, null: false
    add_column :portfolio_item_colors, :dominance_weight, :integer, null: false

    change_column_default(:portfolio_item_colors, :dominance_index, nil)
    change_column_default(:portfolio_item_colors, :dominance_weight, nil)
  end
end
