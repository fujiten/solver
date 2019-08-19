# frozen_string_literal: true

class AddCategoryToQueries < ActiveRecord::Migration[6.0]
  def change
    add_column :queries, :category, :integer, null: false, default: 0
  end
end
