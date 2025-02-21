class AddSellerIdToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :seller_id, :integer
  end
end
