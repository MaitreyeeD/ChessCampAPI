class InstructorSerializer < ActiveModel::Serializer
  attributes :id, :name, :bio, :user, :past_camps, :upcoming_camps, :active
  def past_camps
  	object.camps.past.map do |c|
  		InstructorCampSerializer.new(c)
  	end
  end

  def upcoming_camps
  	object.camps.upcoming.map do |c|
  		InstructorCampSerializer.new(c)
  	end
  end

  def user
  	InstructorUserSerializer.new(object.user)
  end

end
