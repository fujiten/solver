class Quiz < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  has_many :queries, dependent: :destroy

  has_many :users, through: :quiz_statuses
  has_many :quiz_statuses, dependent: :destroy
end
