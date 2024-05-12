class CreateInventoryStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :inventory_statuses do |t|
      t.string :title
      t.string :color
      t.integer :position, null: false, default: 1

      t.timestamps
    end
  end
end
