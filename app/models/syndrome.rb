class Syndrome < ApplicationRecord
  if !Rails.env.test?
    searchkick
  end

  has_one :message, dependent: :destroy
  accepts_nested_attributes_for :message

  has_many :syndrome_symptom_percentage, :class_name => 'SyndromeSymptomPercentage', dependent: :destroy
  has_many :symptoms, :through => :syndrome_symptom_percentage 
end