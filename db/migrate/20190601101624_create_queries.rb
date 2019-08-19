# frozen_string_literal: true

class CreateQueries < ActiveRecord::Migration[6.0]
  def change
    create_table :queries do |t|
      t.string :body, null: false
      t.references :quiz, null: false, foreign_key: true
      t.string :answer, null: false
      t.integer :revealed_point, null: false, default: 0
      t.integer :point, null: false, default: 1

      t.timestamps
    end
  end
end
