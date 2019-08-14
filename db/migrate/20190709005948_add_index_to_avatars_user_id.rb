# frozen_string_literal: true

class AddIndexToAvatarsUserId < ActiveRecord::Migration[6.0]
  def change
    remove_index :avatars, :user_id
    add_index :avatars, :user_id, unique: true
  end
end
