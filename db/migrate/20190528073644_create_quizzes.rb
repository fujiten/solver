class CreateQuizzes < ActiveRecord::Migration[6.0]
  def change
    create_table :quizzes do |t|
      t.string :title, null: false
      t.string :question, null: false
      t.references :user, null: false, foreign_key: true
      t.string :answer, null: false
      t.integer :difficulity, null: false, default: 5

      t.timestamps
    end
  end
end
