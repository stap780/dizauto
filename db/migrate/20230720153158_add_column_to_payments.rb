class AddColumnToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :margin, :integer, default: 0
  end
end
