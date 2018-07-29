class OrdersController < ApplicationController
  before_action :set_order, only: [:show]

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = current_user.orders.build(order_params)
    @order.items.each { |order_item| order_item.price = order_item.purchase_option.price }

    if @order.save
      render :show, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:first_name, :last_name, :city, :address, :zip_code, :phone_number, items_attributes: [:name, :image_url, :item_url, :purchase_option_id])
    end
end
