class CreateClassroom < ActiveRecord::Migration[5.1]
  def change
    create_table :classrooms do |t|
      t.string :floor, null: false
      t.string :number, null: false
      t.references :building, index: true, foreign_key: true
      t.timestamps
    end
  end
end
