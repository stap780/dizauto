class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :number
      t.string :client_id
      t.string :manager_id
      t.string :payment_id
      t.string :delivery_id

      t.timestamps
    end
  end
end
