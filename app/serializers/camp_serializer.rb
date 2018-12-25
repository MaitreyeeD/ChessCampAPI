class CampSerializer < ActiveModel::Serializer
  attributes :id, :curriculum, :location, :instructors, :cost, :start_date, :end_date, :time_slot, :max_students, :is_open, :open_spots, :active
  

  def curriculum
  	CampCurriculumSerializer.new(object.curriculum)
  end
  def location
  	CampLocationSerializer.new(object.location)
  end
  def instructors
    object.instructors.map do |instructor|
    	CampInstructorSerializer.new(instructor)
    end
  end
  def is_open
  	!object.is_full?
  end
  def open_spots
  	object.max_students - object.enrollment
  end


end
