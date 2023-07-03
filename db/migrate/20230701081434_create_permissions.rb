class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.string :model
      t.string :action
      t.integer :user_id

      t.timestamps
    end
  end
end
