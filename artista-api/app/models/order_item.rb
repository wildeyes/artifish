# == Schema Information
#
# Table name: order_items
#
#  id             :bigint(8)        not null, primary key
#  name           :string(255)
#  image_link     :string(255)
#  url_link       :string(255)
#  price_cents    :integer          default(0), not null
#  price_currency :string(255)      default("USD"), not null
#  order_id       :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class OrderItem < ApplicationRecord
  belongs_to :order

  monetize :price_cents
end
