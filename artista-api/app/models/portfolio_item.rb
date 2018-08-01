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
  has_many :purchase_options
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :colors

  def purchase_options_formatted
    purchase_options.group_by(&:material_id)
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
    dominant_colors = image.prominent_colors(color_count).sort_similar_colors
    temp_file.unlink

    tag_colors = []
    dominant_colors.each do |dominant_color|
      tag_colors << @@filter_colors.min_by { |filter_color| calculate_color_diff(dominant_color, filter_color) }
    end
    tag_colors.uniq!
    tag_colors.each do |c|
      begin
        self.colors << c
      rescue ActiveRecord::RecordNotUnique => e
        nil
      end
    end
  end

  private

  def calculate_color_diff(c1, c2)
    d = (c1.r-c2.r)**2 + (c1.g-c2.g)**2 + (c1.b-c2.b)**2
  end
end
