class RenameTableDeliveriesToDeliveryTypes < ActiveRecord::Migration[7.0]
  def change
    rename_table :deliveries, :delivery_types
  end
end
