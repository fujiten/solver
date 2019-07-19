class Avatar < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  belongs_to :user

  validates :user_id, uniqueness: true

  def encode
    encoded_image = Base64.strict_encode64(open(avatar_url).read)
    prefix = 'data:image/png;base64,'
    prefix + encoded_image
  end

  def self.decode_to_imagefile(prefix_encoded_image)
    meta_data = prefix_encoded_image.match(/data:(image|application)\/(.{3,});base64,(.*)/)
    content_type = meta_data[2]
    encoded_image = meta_data[3]
    if content_type == "jpeg" || content_type == "png"
      decoded_image = Base64.strict_decode64(encoded_image)
      image_file = StringIO.new(decoded_image)
    else
      raise error
    end
  end

  private

    def avatar_url
      if image.try(:[], :icon)
        url = image[:icon].url
        url = 'public/' + url if Rails.env.development?
        url
      else
        'public/default.png'
      end
    end

end
