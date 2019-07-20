module ImageEncodable

  def encode(image_size_symbol)
    encoded_image = Base64.strict_encode64(open(avatar_url(image_size_symbol)).read)
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

    def avatar_url(image_size_symbol)
      if image.try(:[], image_size_symbol)
        url = image[image_size_symbol].url
        url = 'public' + url if Rails.env.development?
        url
      else
        'public/default.png'
      end
    end
end
