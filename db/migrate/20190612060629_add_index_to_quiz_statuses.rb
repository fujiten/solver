# frozen_string_literal: true

class AddIndexToQuizStatuses < ActiveRecord::Migration[6.0]
  def change
    add_index :quiz_statuses, [:quiz_id, :user_id], unique: true
  end
end
