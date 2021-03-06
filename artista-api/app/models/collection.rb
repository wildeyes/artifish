# == Schema Information
#
# Table name: collections
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)      not null
#  user_id    :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Collection < ApplicationRecord
  has_one_attached :workspace_image
  has_one_attached :workspace_image_bare
  belongs_to :user
  has_many :items, :class_name => "CollectionItem", dependent: :destroy
  accepts_nested_attributes_for :items, :allow_destroy => true
  attr_accessor :workspace_image_contents
  attr_accessor :workspace_image_bare_contents

  after_save :parse_workspace_image, :parse_workspace_image_bare

  validates_presence_of :name


  def parse_workspace_image
    parse_image(self.workspace_image, self.workspace_image_contents)
  end

  def parse_workspace_image_bare
    parse_image(self.workspace_image_bare, self.workspace_image_bare_contents)
  end

  private

  def parse_image(attachment, attachment_contents)
    # If directly uploaded
    unless attachment_contents.nil? || attachment_contents[/(image\/[a-z]{3,4})|(application\/[a-z]{3,4})/] == ''
      content_type = attachment_contents[/(image\/[a-z]{3,4})|(application\/[a-z]{3,4})/]
      content_type = content_type[/\b(?!.*\/).*/]
      contents = attachment_contents.sub /data:((image|application)\/.{3,}),/, ''
      decoded_data = Base64.decode64(contents)
      filename = name + '_workspace_' + Time.zone.now.strftime("%Y_%m_%d_%H_%M_%S") + '.' + content_type
      dir = "#{Rails.root}/tmp/images/"
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      File.open("#{Rails.root}/tmp/images/#{filename}", 'wb') do |f|
        f.write(decoded_data)
      end
      attachment.attach(io: File.open("#{Rails.root}/tmp/images/#{filename}"), filename: filename)
      FileUtils.rm("#{Rails.root}/tmp/images/#{filename}")
    end
  end

end
