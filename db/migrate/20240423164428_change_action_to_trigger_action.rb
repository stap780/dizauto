class ChangeActionToTriggerAction < ActiveRecord::Migration[7.1]
  def change
    rename_table :actions, :trigger_actions
  end
end
