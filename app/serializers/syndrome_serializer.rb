class SyndromeSerializer < ActiveModel::Serializer
  attributes :id, :description, :details

  has_one :message
  has_many :symptoms

  def symptoms
    return object.symptoms.map do |symptom|
      obj = symptom.as_json({only: [:description]})
      if SyndromeSymptomPercentage.where(syndrome:object,symptom:symptom).any?
        obj[:percentage] = SyndromeSymptomPercentage.where(syndrome:object,symptom:symptom)[0].percentage
      else
        obj[:percentage] = 0
      end
      obj
    end
  end
end
