class Query < ApplicationRecord
  belongs_to :quiz

  has_many :query_status, dependent: :destroy
  has_many :quiz_statuses, through: :query_statuses

  enum category: { "不明" => 0, Who: 1, What: 2, When: 3, Where: 4, Why: 5, How: 6}
end
