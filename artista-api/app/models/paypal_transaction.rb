# == Schema Information
#
# Table name: paypal_transactions
#
#  id                           :bigint(8)        not null, primary key
#  token                        :string(255)
#  payer                        :string(255)
#  processor_authorization_code :string(255)
#  order_id                     :bigint(8)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#

class PaypalTransaction < ApplicationRecord
  belongs_to :order

  monetize :amount_cents
end
