class AddPositionToDeliveryTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :delivery_types, :position, :integer, null: false, default: 1
  end
end
