class AddInsaleClientIdToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :insid, :integer
  end
end
