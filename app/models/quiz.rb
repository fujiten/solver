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

  def arrange_me_and_fetch_associations
    json = 
    { id:           self.id,
      title:        self.title,
      question:     self.question,
      answer:       self.answer,
      difficulity:  self.difficulity,
      created_at:   self.created_at,
      updated_at:   self.updated_at,
      published:    self.published,
      author:       self.author,
      avatar:       self.author.avatar.encode }
    json
  end

  def self.arrange_quizzes(quizzes)
    json = quizzes.map{ |quiz| quiz.arrange_me_and_fetch_associations }
    json
  end

end
