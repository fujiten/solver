class User < ApplicationRecord
  has_secure_password

  has_many :my_quizzes, class_name: "Quiz", dependent: :destroy
  has_many :quizzes, through: :quiz_statuses, dependent: :destroy
  has_many :quiz_statuses 
end
