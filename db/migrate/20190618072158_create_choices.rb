# frozen_string_literal: true

class CreateChoices < ActiveRecord::Migration[6.0]
  def change
    create_table :choices do |t|
      t.string :body, null: false
      t.boolean :correctness, null: false, default: false
      t.references :quiz, null: false, foreign_key: true

      t.timestamps
    end
  end
end
