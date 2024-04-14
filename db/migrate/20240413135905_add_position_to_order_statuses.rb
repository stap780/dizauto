class AddPositionToOrderStatuses < ActiveRecord::Migration[7.1]
  def change
    add_column :order_statuses, :position, :integer, null: false, default: 1
  end
end
