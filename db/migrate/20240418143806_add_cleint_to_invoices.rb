class AddCleintToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_reference :invoices, :client, null: false, foreign_key: true
  end
end
