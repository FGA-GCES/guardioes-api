# frozen_string_literal: true

class Group < ApplicationRecord
  acts_as_paranoid
  searchkick

  belongs_to :manager
  has_many :users
end
