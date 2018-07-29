class PortfolioItemsController < ApplicationController
  skip_before_action :authorize_request

  # GET /portfolio_items
  def index
    query_tags = []
    query_tags = params[:tags].split(' ') if params[:tags]
    color = hex_to_color(params[:color]) if params[:color]

    @portfolio_items = PortfolioItem.joins(:tags).where.has{ tags.name.in query_tags } if query_tags.present?
    @portfolio_items = (@portfolio_items || PortfolioItem).joins(:colors).where.has{ colors.id == color.id } if color.present?

    @portfolio_items
  end

  private

  def hex_to_color(hex_color)
    m = hex_color.match /#(..)(..)(..)/
    Color.where(r: m[1].hex, g: m[2].hex, b: m[3].hex).first
  end
end
