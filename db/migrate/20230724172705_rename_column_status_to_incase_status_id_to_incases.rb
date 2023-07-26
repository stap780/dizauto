class RenameColumnStatusToIncaseStatusIdToIncases < ActiveRecord::Migration[7.0]
  def change
    rename_column :incases, :status, :incase_status_id
    rename_column :incases, :tip, :incase_tip_id
  end
end
