# == Schema Information
#
# Table name: colors
#
#  id :bigint(8)        not null, primary key
#  r  :integer
#  g  :integer
#  b  :integer
#  h  :float(24)
#  s  :float(24)
#  l  :float(24)
#

class Color < ApplicationRecord
  has_and_belongs_to_many :portfolio_items

  def to_hex
    Camalian::Color.new(self.r, self.g, self.b).to_hex
  end
end
