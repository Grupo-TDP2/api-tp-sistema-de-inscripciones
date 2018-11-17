class AddAttributeToImport < ActiveRecord::Migration[5.1]
  def change
    add_column :import_files, :proccesed_errors, :string
  end
end
