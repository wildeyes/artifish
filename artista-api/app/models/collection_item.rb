# == Schema Information
#
# Table name: collection_items
#
#  id                  :bigint(8)        not null, primary key
#  name                :string(255)
#  image_url           :string(255)
#  item_url            :string(255)
#  price_cents         :integer          default(0), not null
#  price_currency      :string(255)      default("USD"), not null
#  collection_id       :bigint(8)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  portfolio_item_id   :bigint(8)
#  position_attributes :text(65535)
#

class CollectionItem < ApplicationRecord
  belongs_to :collection
  belongs_to :portfolio_item

  monetize :price_cents
  serialize :position_attributes
end
