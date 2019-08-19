# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password = Faker::Internet.password(6)
    name                  { Faker::Name.name }
    email                 { Faker::Internet.email }
    password              { password }
    password_confirmation { password }
    after :create do |user|
      create :avatar, user: user             # has_one
    end
  end
end
