class User < ApplicationRecord
  has_secure_password

  has_many :my_quizzes, class_name: "Quiz", dependent: :destroy
  has_many :quiz_statuses, dependent: :destroy
  has_many :trying_quizzes, through: :quiz_statuses, source: :quiz

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX },                    
                    uniqueness: true,
                    allow_blank: true
  validates :name,  presence: true,
                    length: { maximum: 16 }
  validates :password, length: { minimum: 6, maximum: 30 }, allow_blank: true
                    

end
