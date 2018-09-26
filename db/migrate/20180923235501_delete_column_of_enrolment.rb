class DeleteColumnOfEnrolment < ActiveRecord::Migration[5.1]
  def change
    remove_column :enrolments, :valid_enrolment_datetime
  end
end
