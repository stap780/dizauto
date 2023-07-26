class AddColumnColorToOrderStatuses < ActiveRecord::Migration[7.0]
  def change
    add_column :order_statuses, :color, :string
  end
end
