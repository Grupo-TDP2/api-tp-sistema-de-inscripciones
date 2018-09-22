class CreateCourse < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.integer :vacancies, null: false
      t.references :subject, index: true, foreign_key: true
      t.references :school_term, index: true, foreign_key: true
      t.timestamps
    end
  end
end
