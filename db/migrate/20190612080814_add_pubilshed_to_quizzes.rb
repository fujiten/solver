# frozen_string_literal: true

class AddPubilshedToQuizzes < ActiveRecord::Migration[6.0]
  def change
    add_column :quizzes, :published, :integer, index: true, default: 0, null: false
  end
end
