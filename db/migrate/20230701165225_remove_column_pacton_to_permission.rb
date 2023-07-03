class RemoveColumnPactonToPermission < ActiveRecord::Migration[7.0]
  def change
    remove_column :permissions, :paction
  end
end
