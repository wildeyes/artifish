json.extract! paypal_transaction, :id, :amount_cents, :created_at, :updated_at
json.amount_formatted paypal_transaction.amount.format
json.order paypal_transaction.order, partial: 'orders/order', as: :order
