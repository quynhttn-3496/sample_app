class User < ApplicationRecord
  before_save :downcase_email

  ATTRIBUTE_PERMITTED = %i(name email password password_confirmation).freeze

  validates :name, presence: true, length: {maximum: Settings.MAX_LENGTH_NAME}

  validates :email, presence: true, length:
    {maximum: Settings.MAX_LENGTH_EMAIL},
    format: {with: Settings.EMAIL_REGEX}, uniqueness: true

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
