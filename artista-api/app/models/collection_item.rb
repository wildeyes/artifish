class CollectionItem < ApplicationRecord
  belongs_to :collection

  monetize :price_cents
end
