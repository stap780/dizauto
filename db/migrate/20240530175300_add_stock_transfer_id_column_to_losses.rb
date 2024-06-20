class AddStockTransferIdColumnToLosses < ActiveRecord::Migration[7.1]
  def change
    add_column :losses, :stock_transfer_id, :integer
  end
end
