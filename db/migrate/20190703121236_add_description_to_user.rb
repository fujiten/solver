# frozen_string_literal: true

class AddDescriptionToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :description, :string, null: false, default: ""
  end
end
