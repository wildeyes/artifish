json.extract! order, :id, :first_name, :last_name, :city, :address, :zip_code, :phone_number, :user_id, :created_at, :updated_at
json.items order.items, partial: 'order_items/order_item', as: :order_item
