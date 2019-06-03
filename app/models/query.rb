class Query < ApplicationRecord
  belongs_to :quiz

  enum category: { "不明" => 0, Who: 1, What: 2, When: 3, Where: 4, Why: 5, How: 6}
end
