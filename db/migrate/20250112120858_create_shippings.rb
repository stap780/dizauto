class CreateShippings < ActiveRecord::Migration[7.1]
  def change
    create_table :shippings do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.datetime :date
      t.datetime :time_from
      t.datetime :time_to
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
