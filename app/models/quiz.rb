class Quiz < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  has_many :queries, dependent: :destroy

  has_many :quiz_statuses, dependent: :destroy
  has_many :tried_users, through: :quiz_statuses, source: :user

  has_many :choices

  enum published: { drafted: 0, published: 1 }
end
