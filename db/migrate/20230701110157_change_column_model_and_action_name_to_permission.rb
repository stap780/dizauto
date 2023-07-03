class ChangeColumnModelAndActionNameToPermission < ActiveRecord::Migration[7.0]
  def change
    rename_column :permissions, :model, :pmodel
    rename_column :permissions, :action, :paction
  end
end
