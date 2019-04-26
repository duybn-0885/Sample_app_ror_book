class Micropost < ApplicationRecord
  belongs_to :user
  scope :ordered_by_created_at, -> { order(created_at: :asc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: Settings.maximum_length_micropost }
  validate  :picture_size

  private
    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > Settings.maximum_picturesize.megabytes
        errors.add(:picture, t("image_limit_size"))
      end
    end
end
