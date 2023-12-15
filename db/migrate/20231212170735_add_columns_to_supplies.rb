class AddColumnsToSupplies < ActiveRecord::Migration[7.0]
  def change
    remove_column :supplies, :warehouse_id
    add_column :supplies, :title, :string
    add_column :supplies, :in_number, :string
    add_column :supplies, :in_date, :datetime
    add_column :supplies, :supply_status_id, :integer
  end
end
