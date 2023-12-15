class CreateSupplyStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :supply_statuses do |t|
      t.string :title
      t.string :color
      t.integer :position

      t.timestamps
    end
  end
end
