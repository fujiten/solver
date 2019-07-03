FactoryBot.define do
  factory :quiz do
    title           { Faker::Lorem.word }
    question        { Faker::Lorem.sentence }
    answer          { Faker::Lorem.sentence }
    association :author, factory: :user
  end
end
