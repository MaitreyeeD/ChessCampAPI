class CampCurriculumSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :min_rating, :max_rating, :active
  
end
