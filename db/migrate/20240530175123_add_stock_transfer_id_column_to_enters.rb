class AddStockTransferIdColumnToEnters < ActiveRecord::Migration[7.1]
  def change
    add_column :enters, :stock_transfer_id, :integer
  end
end
