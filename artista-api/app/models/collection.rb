# == Schema Information
#
# Table name: collections
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Collection < ApplicationRecord
  has_one_attached :workspace_image
  belongs_to :user
  has_many :items, :class_name => "CollectionItem"
  attr_accessor :workspace_image_contents

  after_create :parse_image

  validates_presence_of :name

  def parse_image
    # If directly uploaded
    unless self.workspace_image_contents.nil? || self.workspace_image_contents[/(image\/[a-z]{3,4})|(application\/[a-z]{3,4})/] == ''
      content_type = self.workspace_image_contents[/(image\/[a-z]{3,4})|(application\/[a-z]{3,4})/]
      content_type = content_type[/\b(?!.*\/).*/]
      contents = self.workspace_image_contents.sub /data:((image|application)\/.{3,}),/, ''
      decoded_data = Base64.decode64(contents)
      filename = name + '_workspace_' + Time.zone.now.strftime("%Y_%m_%d_%H_%M_%S") + '.' + content_type
      dir = "#{Rails.root}/tmp/images/"
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      File.open("#{Rails.root}/tmp/images/#{filename}", 'wb') do |f|
        f.write(decoded_data)
      end
      self.workspace_image.attach(io: File.open("#{Rails.root}/tmp/images/#{filename}"), filename: filename)
      FileUtils.rm("#{Rails.root}/tmp/images/#{filename}")
    end
  end

end
