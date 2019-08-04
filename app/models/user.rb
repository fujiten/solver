class User < ApplicationRecord
  before_save { self.email = email.downcase }

  has_secure_password

  has_many :my_quizzes, class_name: "Quiz", dependent: :destroy
  has_many :quiz_statuses, dependent: :destroy
  has_many :trying_quizzes, through: :quiz_statuses, source: :quiz
  has_one :avatar, dependent: :destroy

  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX },                    
                    uniqueness: { case_sensitive: false },
                    allow_blank: true
  validates :name,  presence: true,
                    length: { maximum: 16 }
  validates :password, length: { minimum: 6, maximum: 30 }, allow_blank: true

  def create_user_and_avatar
    begin
      ActiveRecord::Base.transaction do
        save!
        Avatar.create(user_id: user.id)
      end
    rescue => exception
      false
    end
  end
                    
  def self.find_or_create(user_info, provider)
    where(provider: provider, uid: user_info['id']).first_or_create do |user|
      if user_info['email']
        user.email = user_info['email']
      else
        user.email = "uid.#{user_info['id']}@example.com"
      end
      user.name = user_info['name']
      user.password = Faker::Internet.password(10, 20)
      user.build_avatar(image: open(user_info['profile_image_url_https']))
    end
  end

end
