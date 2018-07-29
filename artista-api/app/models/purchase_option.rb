# == Schema Information
#
# Table name: purchase_options
#
#  id                :bigint(8)        not null, primary key
#  material_id       :bigint(8)
#  size_id           :bigint(8)
#  portfolio_item_id :bigint(8)
#  price_cents       :integer          default(0), not null
#  price_currency    :string(255)      default("USD"), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class PurchaseOption < ApplicationRecord
  belongs_to :material
  belongs_to :size
  belongs_to :portfolio_item

  monetize :price_cents
end
