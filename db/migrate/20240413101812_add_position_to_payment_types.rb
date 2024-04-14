class AddPositionToPaymentTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :payment_types, :position, :integer, null: false, default: 1

  end
end
