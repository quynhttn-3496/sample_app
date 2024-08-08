class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  scope :newest, ->{order(created_at: :desc)}
  scope :recent_posts, ->{order created_at: :desc}
  scope :relate_post, ->(user_ids){where user_id: user_ids}

  validates :content, presence: true,
            length: {maximum: Settings.digits.digit_140}
  validates :image, content_type: {in: Settings.accept_file,
                                   message: I18n.t("image.must_valid_image")},
                                   size: {less_than: Settings.file_5.megabytes,
                                          message: I18n.t("image.should_be")}

  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: Settings.resize_image
  end
end
