class RenameInsaleClientIdToInsidForProductionEnvironment < ActiveRecord::Migration[7.1]
  def change
    rename_column :clients, :insale_client_id, :insid unless Rails.env.development?
  end
end
