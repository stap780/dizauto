class ChangeColumnActionParamsTypyToAction < ActiveRecord::Migration[7.1]
  def change
    change_column :actions, :action_params, :text, null: false
  end
end
