class RemoveColumnActionToTriggers < ActiveRecord::Migration[7.0]
  def change
    remove_column :triggers, :action
  end
end
