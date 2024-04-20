class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.integer :company_id
      t.string :number
      t.integer :invoice_status_id
      t.integer :order_id

      t.timestamps
    end
  end
end
