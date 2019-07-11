class Quiz < ApplicationRecord
  belongs_to :author, class_name: "User", foreign_key: "user_id"
  has_many :queries, dependent: :destroy

  has_many :quiz_statuses, dependent: :destroy
  has_many :tried_users, through: :quiz_statuses, source: :user

  has_many :choices, dependent: :destroy

  enum published: { drafted: 0, published: 1 }

  validates :title,     presence: true,
                        length: { maximum: 20 }
  validates :question,  presence: true,
                        length: { maximum: 400 }
  validates :answer,    presence: true,
                        length: { maximum: 1000 }
end
