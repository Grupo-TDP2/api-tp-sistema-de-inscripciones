class AddDeviceTokenToStudents < ActiveRecord::Migration[5.1]
  def change
    add_column :students, :device_token, :string
  end
end
