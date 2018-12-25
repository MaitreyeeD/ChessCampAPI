class CurriculumSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :min_rating, :max_rating, :active, :past_camps, :upcoming_camps
  def past_camps
  	object.camps.past.map do |c|
  		CurriculumCampSerializer.new(c)
  	end
  end

  def upcoming_camps
  	object.camps.upcoming.map do |c|
  		CurriculumCampSerializer.new(c)
  	end
  end
end
