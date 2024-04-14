class ChangeColumnValueTypeToAction < ActiveRecord::Migration[7.1]
  def up
    change_column :actions, :value, :string, null: false
    change_column_default :actions, :value, nil
  end
  def down 
    change_column :actions, :value, :text, null: false
    change_column_default :actions, :value, {}
  end
end
