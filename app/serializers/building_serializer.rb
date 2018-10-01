class BuildingSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :postal_code, :city
end
