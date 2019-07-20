class Avatar < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  include ImageEncodable

  belongs_to :user

  validates :user_id, uniqueness: true

end
