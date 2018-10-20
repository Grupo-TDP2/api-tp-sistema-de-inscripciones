class CreateImportFile < ActiveRecord::Migration[5.1]
  def change
    create_table :import_files do |t|
      t.string :filename, null: false
      t.integer :model, null: false
      t.integer :rows_successfuly_processed, null: false
      t.integer :rows_unsuccessfuly_processed, null: false
      t.timestamps
    end
  end
end
