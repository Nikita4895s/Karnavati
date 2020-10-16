class CelloMaster < ApplicationRecord
  # has_one_attached :product_image
  mount_uploader :product_image, ImageUploader
  enum product_mode: %w(FAST MEDIUM SLOW)
end
