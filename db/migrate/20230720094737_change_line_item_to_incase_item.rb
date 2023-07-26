class ChangeLineItemToIncaseItem < ActiveRecord::Migration[7.0]
  def change
    rename_table :line_items, :incase_items
  end
end
