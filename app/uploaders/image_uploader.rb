class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  # include CarrierWave::ImageOptimizer
  include Cloudinary::CarrierWave

  # process :convert => 'png'
  # process :tags => ['team_registration']
  # process :resize_to_fill => [300, 300, :north]

  def store_dir
    # "images/#{model.class.to_s.underscore}/#{model.team_name}"
    "images/product_images/"
  end

  # def public_id
  #   "https://karnavati.herokuapp.com/product_images/"
  # end  

  def cache_dir
      "/tmp/cache/#{model.class.to_s.underscore}"
  end

  def filename
    if model.link_url.present?
      "#{model.product_name}" + ".png" unless original_filename.present?
    end
  end

  def content_type_whitelist
      /image\//
  end

  def extension_white_list
      %w(jpg jpeg gif png)
  end

end
