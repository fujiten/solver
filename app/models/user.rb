class User < ApplicationRecord
  has_secure_password

  has_many :quizzes, through: :quiz_statuses
  has_many :quiz_statuses 
end
