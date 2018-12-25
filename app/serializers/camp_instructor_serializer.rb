class CampInstructorSerializer < ActiveModel::Serializer
  attributes :id, :name, :bio, :email, :phone, :active
  
end
