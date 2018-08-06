# == Schema Information
#
# Table name: portfolio_items
#
#  id                 :bigint(8)        not null, primary key
#  name               :string(255)
#  product_identifier :string(255)
#  product_url        :string(255)
#  supplier_id        :bigint(8)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class PortfolioItem < ApplicationRecord
  has_one_attached :image
  belongs_to :supplier
  has_many :purchase_options, dependent: :destroy
  has_and_belongs_to_many :tags
  has_many :portfolio_item_colors
  has_many :colors, :through => :portfolio_item_colors

  def purchase_options_formatted
    group = purchase_options.joins(:material).where.has{material.enabled == true}.group_by(&:material_id)
    group.each{|material_id, purchase_options| purchase_options.sort_by!(&:size_id)}
    group
  end

  def calculate_starting_price
    min_purchase_option = purchase_options.min_by(&:price_cents)
    min_purchase_option ? min_purchase_option.price : nil
  end

  def extract_colors(color_count = 5)
    @@filter_colors ||= Color.all

    filename = self.image.filename.to_s
    temp_file = Tempfile.new(filename)
    temp_file.binmode
    temp_file.write(self.image.download)
    temp_file.close

    image = Camalian::load(temp_file.path)
    dominant_colors = image.prominent_colors(color_count)#.sort_similar_colors
    temp_file.unlink

    tag_colors = {}
    dominant_colors.each_with_index do |dominant_color, index|
      tag_color = @@filter_colors.min_by { |filter_color| calculate_color_diff(dominant_color, filter_color) }
      dominance_weight = calculate_color_diff(dominant_color, tag_color)
      tag_colors[tag_color] ||= {}
      tag_colors[tag_color][:dominance_index] ||= index
      if tag_colors[tag_color][:dominance_weight]
        tag_colors[tag_color][:dominance_weight] = [dominance_weight, tag_colors[tag_color][:dominance_weight]].min
      else
        tag_colors[tag_color][:dominance_weight] = dominance_weight
      end
    end
    tag_colors.each do |c, dominance_hash|
      begin
        self.portfolio_item_colors.create!(color_id: c.id, dominance_index: dominance_hash[:dominance_index], dominance_weight: dominance_hash[:dominance_weight].to_i)
      rescue ActiveRecord::RecordNotUnique => e
        nil
      end
    end
  end

  private

  def calculate_color_diff(c1, c2)
    d = Math.sqrt((c1.r-c2.r)**2 + (c1.g-c2.g)**2 + (c1.b-c2.b)**2)
  end
end
