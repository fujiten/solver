FactoryBot.define do
  factory :quiz do
    title           { Faker::Lorem.word }
    question        { Faker::Lorem.sentence }
    answer          { Faker::Lorem.sentence }
    image_data      { Shrine.uploaded_file(
                        'id' => SecureRandom.hex(8),
                        'storage' => 'cache',
                        'metadata' => { 'mime_type' => 'image/jpeg', 'size' => 1.megabyte }).to_json }
    association :author, factory: :user
  end
end
