class CreateQuizStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :quiz_statuses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.integer :total_points, null: false, default: 0
      t.integer :query_times, null: false, default: 0
      t.boolean :be_solved, null:false, default: false

      t.timestamps
    end
  end
end
