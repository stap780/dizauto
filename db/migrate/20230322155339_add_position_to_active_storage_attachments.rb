class AddPositionToActiveStorageAttachments < ActiveRecord::Migration[7.0]
  def change
    add_column :active_storage_attachments, :position, :integer, default: 1
  end
end
