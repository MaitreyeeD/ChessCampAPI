class LocationSerializer < ActiveModel::Serializer
  attributes :id, :name, :street_1, :street_2, :city, :state, :zip, :max_capacity, :active, :past_camps, :upcoming_camps

  def past_camps
  	object.camps.past.map do |c|
  		LocationCampSerializer.new(c)
  	end
  end

  def upcoming_camps
  	object.camps.upcoming.map do |c|
  		LocationCampSerializer.new(c)
  	end
  end

end
