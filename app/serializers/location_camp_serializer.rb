class LocationCampSerializer < ActiveModel::Serializer
  attributes :id, :curriculum_name, :cost, :start_date, :end_date, :time_slot, :active
  def curriculum_name
  	object.curriculum.name
  end
  
end
