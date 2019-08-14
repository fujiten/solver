# frozen_string_literal: true

class AddColumnToQuizStatuses < ActiveRecord::Migration[6.0]
  def change
    add_column :quiz_statuses, :failed_answer_times, :integer, null: false, default: 0
  end
end
