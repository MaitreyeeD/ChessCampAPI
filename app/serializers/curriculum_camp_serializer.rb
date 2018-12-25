class CurriculumCampSerializer < ActiveModel::Serializer
  attributes :id, :location_name, :cost, :start_date, :end_date, :time_slot, :active
  def location_name
  	object.location.name
  end
  
end
