class ImportFile < ApplicationRecord
  validates :filename, :model, :rows_successfuly_processed, :rows_unsuccessfuly_processed,
            :proccesed_errors, presence: true

  enum model: { student: 0, teacher: 1 }
end
