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
  has_many :portfolio_item_colors
  has_many :portfolio_items, :through => :portfolio_item_colors

  def to_hex
    Camalian::Color.new(self.r, self.g, self.b).to_hex
  end
end
