class Quiz < ApplicationRecord
  belongs_to :user
  has_many :queries

  has_many :users, through: :quiz_statuses
  has_many :quiz_statuses
end
