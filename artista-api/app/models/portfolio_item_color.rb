class PortfolioItemColor < ApplicationRecord
  # Validations
  validates_presence_of :portfolio_item, :color

  # Relations
  belongs_to :portfolio_item
  belongs_to :color
end
