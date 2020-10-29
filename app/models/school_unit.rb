# frozen_string_literal: true

class SchoolUnit < ApplicationRecord
  belongs_to :user, optional: true
end
