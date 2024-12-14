class AddInsaleClientIdToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :insale_id, :integer
  end
end
