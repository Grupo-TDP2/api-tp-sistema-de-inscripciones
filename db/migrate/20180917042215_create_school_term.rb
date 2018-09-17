class CreateSchoolTerm < ActiveRecord::Migration[5.1]
  def change
    create_table :school_terms do |t|
      t.integer :term, null: false
      t.integer :year, null: false
      t.date :date_start, null: false
      t.date :date_end, null: false
      t.timestamps
    end
  end
end
