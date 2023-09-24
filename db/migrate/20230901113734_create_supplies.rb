class CreateSupplies < ActiveRecord::Migration[7.0]
  def change
    create_table :supplies do |t|
      t.integer :company_id
      t.integer :warehouse_id

      t.timestamps
    end
  end
end
