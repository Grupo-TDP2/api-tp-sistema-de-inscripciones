class SchoolTermSerializer < ActiveModel::Serializer
  attributes :id, :year, :term, :date_start, :date_end
end
