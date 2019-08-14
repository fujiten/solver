# frozen_string_literal: true

class QueryStatus < ApplicationRecord
  belongs_to :query
  belongs_to :quiz_status

  validates :query_id, uniqueness: {scope: :quiz_status_id}
end
