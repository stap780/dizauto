class RenameTablePaymentsToPaymentTypes < ActiveRecord::Migration[7.0]
  def change
    rename_table :payments, :payment_types
  end
end
