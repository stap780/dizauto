class ChangeColumnsNameToAction < ActiveRecord::Migration[7.1]
  def change
    rename_column :actions, :action_name, :name
    rename_column :actions, :action_params, :value
  end
end
