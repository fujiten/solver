class CreateQueryStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :query_statuses do |t|
      t.references :query, null: false, foreign_key: true
      t.references :quiz_status, null: false, foreign_key: true

      t.index [:query_id, :quiz_status_id], unique: true
    end
  end
end
