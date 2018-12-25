class InstructorUserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :role, :phone
end
