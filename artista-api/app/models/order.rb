# == Schema Information
#
# Table name: orders
#
#  id           :bigint(8)        not null, primary key
#  first_name   :string(255)
#  last_name    :string(255)
#  city         :string(255)
#  address      :string(255)
#  zip_code     :string(255)
#  phone_number :string(255)
#  user_id      :bigint(8)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Order < ApplicationRecord
  has_one :paypal_transaction
  belongs_to :user
  has_many :items, :class_name => "OrderItem", dependent: :destroy
  accepts_nested_attributes_for :items, :allow_destroy => true
end
