class RemoveColumnStatusToIncaseItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :incase_items, :status
  end
end
