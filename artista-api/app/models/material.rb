# == Schema Information
#
# Table name: materials
#
#  id            :bigint(8)        not null, primary key
#  name          :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  material_type :string(255)      not null
#  enabled       :boolean          default(FALSE)
#

class Material < ApplicationRecord
  default_scope { where(:enabled => true) }
end
