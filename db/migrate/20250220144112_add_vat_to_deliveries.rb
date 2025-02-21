class AddVatToDeliveries < ActiveRecord::Migration[7.1]
  def change
    add_column :deliveries, :vat, :integer, default: 0, null: false
  end
end
