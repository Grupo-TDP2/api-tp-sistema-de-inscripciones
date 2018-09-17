class CreateBuilding < ActiveRecord::Migration[5.1]
  def change
    create_table :buildings do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :postal_code, null: false
      t.string :city, null: false
      t.timestamps
    end
  end
end
