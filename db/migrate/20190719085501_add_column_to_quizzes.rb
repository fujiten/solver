# frozen_string_literal: true

class AddColumnToQuizzes < ActiveRecord::Migration[6.0]
  def change
    add_column :quizzes, :image_data, :text
  end
end
