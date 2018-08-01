class PortfolioItemsController < ApplicationController
  skip_before_action :authorize_request

  # GET /portfolio_items
  def index
    query_tags = []
    query_tags = params[:tags].split(' ') if params[:tags]
    color = hex_to_color(params[:color]) if params[:color]

    @portfolio_items = PortfolioItem.joins(:tags).where.has{ tags.name.in query_tags } if query_tags.present?
    @portfolio_items = (@portfolio_items || PortfolioItem).joins(:colors).where.has{ colors.id == color.id } if color.present?

    if @portfolio_items.nil?
      random_tags = Tag.all.sample(5)
      portfolio_items_ids = []
      random_tags.each { |tag| portfolio_items_ids += tag.portfolio_items.last(20).pluck(:id).sample(4) }
      @portfolio_items = PortfolioItem.where(:id => portfolio_items_ids)
    end

    # Getting starting price
    @portfolio_items = @portfolio_items.joins(:purchase_options)
    .select("MIN(purchase_options.price_cents) as starting_price")
    .select("purchase_options.price_currency")
    .select("portfolio_items.*").group('portfolio_items.id, purchase_options.price_currency') if @portfolio_items

    @portfolio_items
  end

  private

  def hex_to_color(hex_color)
    m = hex_color.match /#(..)(..)(..)/
    Color.where(r: m[1].hex, g: m[2].hex, b: m[3].hex).first
  end
end
