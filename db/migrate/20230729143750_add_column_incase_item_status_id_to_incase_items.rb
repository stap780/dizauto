class AddColumnIncaseItemStatusIdToIncaseItems < ActiveRecord::Migration[7.0]
  def change
    add_column :incase_items, :incase_item_status_id, :integer
  end
end
