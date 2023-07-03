class AddColumnPactonsToPermission < ActiveRecord::Migration[7.0]
  def change
    add_column :permissions, :pactions, :text, array: true, default: []
  end
end
