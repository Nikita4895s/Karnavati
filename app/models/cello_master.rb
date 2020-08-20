class CelloMaster < ApplicationRecord
  has_one_attached :product_image
  enum product_mode: %w(High Low Medium)
end
