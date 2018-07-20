# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  email             :string(255)
#  password_digest   :string(255)
#  is_verified       :boolean
#  verification_code :string(255)
#  first_name        :string(255)      not null
#  last_name         :string(255)      not null
#  provider          :string(255)      default("email"), not null
#  uid               :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class User < ApplicationRecord
  # encrypt password
  has_secure_password

  # validations
  validates_presence_of :email, :password_digest
  validates :email, uniqueness: { scope: :provider }, email: true
  validates :uid, uniqueness: { scope: :provider }
  validates :password, length: { minimum: 6 }, allow_nil: true

  # callbacks
  before_create :default_uid_with_email

  def default_uid_with_email
    self.uid ||= self.email
  end
end
