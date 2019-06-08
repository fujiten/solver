class QuizStatus < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
end
