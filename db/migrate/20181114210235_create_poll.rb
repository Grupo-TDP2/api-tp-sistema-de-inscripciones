class CreatePoll < ActiveRecord::Migration[5.1]
  def change
    create_table :polls do |t|
      t.integer :rate, null: false
      t.text :comment, null: false
      t.belongs_to :course, null: false, index: true
      t.belongs_to :student, null: false, index: true
      t.timestamps
    end
  end
end
