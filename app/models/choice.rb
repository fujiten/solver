class Choice < ApplicationRecord
  belongs_to :quiz

  validates :body,        presence: true,
                          length: { maximum: 60 }
  validates :correctness, inclusion: { in: [true, false] }
end
