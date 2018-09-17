class CreateSubject < ActiveRecord::Migration[5.1]
  def change
    create_table :subjects do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.integer :credits, null: false
      t.references :department, index: true, foreign_key: true

      t.timestamps
    end
  end
end
