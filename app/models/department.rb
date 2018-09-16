class Department < ApplicationRecord
  validates :name, :code, presence: true
  validates :code, numericality: true, length: { is: 2 }
  validates :name, uniqueness: { case_sensitive: false }
  validates :code, uniqueness: { case_sensitive: false }
end
