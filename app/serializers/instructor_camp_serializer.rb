class InstructorCampSerializer < ActiveModel::Serializer
  attributes :id, :curriculum_name, :location_name, :cost, :start_date, :end_date, :time_slot, :active
  def location_name
  	object.location.name
  end
  def curriculum_name
  	object.curriculum.name
  end
  
end
