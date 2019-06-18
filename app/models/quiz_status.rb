class QuizStatus < ApplicationRecord
  belongs_to :user
  belongs_to :quiz

  has_many :query_statuses, dependent: :destroy
  has_many :done_queries, through: :query_statuses, source: :query

  validates :user_id, uniqueness: {scope: :quiz_id}
end
