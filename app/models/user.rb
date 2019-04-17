class User < ApplicationRecord

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: Settings.maximum_length_name }
  validates :email, presence: true, length: { maximum: Settings.maximum_length_email }, format: { with: Settings.valid_email_regex }, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: { minimum: Settings.minimum_length_password }, allow_nil: true

  has_secure_password
end
