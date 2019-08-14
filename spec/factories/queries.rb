# frozen_string_literal: true

FactoryBot.define do
  factory :query do
    body            { Faker::Lorem.sentence }
    answer          { Faker::Lorem.sentence }
    revealed_point  { Random.rand(1..1000) }
    point           { Random.rand(1..100) }
    association :quiz, factory: :quiz
  end
end
