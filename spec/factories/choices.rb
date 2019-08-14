# frozen_string_literal: true

FactoryBot.define do
  factory :choice do
    body            { Faker::Lorem.sentence }
    correctness     { [true, false].sample }
    association :quiz, factory: :quiz
  end
end
