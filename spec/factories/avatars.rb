FactoryBot.define do
  factory :avatar do
    association :user
    image_data { Shrine.uploaded_file(
      'id' => SecureRandom.hex(8),
      'storage' => 'cache',
      'metadata' => { 'mime_type' => 'image/jpeg', 'size' => 1.megabyte }).to_json }
  end
end
