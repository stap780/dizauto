class CreateDeliveries < ActiveRecord::Migration[7.0]
  def change
    create_table :deliveries do |t|
      t.string :title
      t.decimal :price
      t.string :desc

      t.timestamps
    end
  end
end
