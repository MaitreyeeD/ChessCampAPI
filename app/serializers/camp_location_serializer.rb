class CampLocationSerializer < ActiveModel::Serializer
  attributes :id, :name, :street_1, :street_2, :city, :state, :zip, :max_capacity, :active
  
end
