class AddPortfolioItemToCollectionItem < ActiveRecord::Migration[5.2]
  def change
    add_reference :collection_items, :portfolio_item
  end
end
