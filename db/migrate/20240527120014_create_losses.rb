class CreateLosses < ActiveRecord::Migration[7.1]
  def change
    create_table :losses do |t|
      t.references :loss_status, null: false, foreign_key: true
      t.string :title
      t.datetime :date
      t.references :warehouse, null: false, foreign_key: true
      t.integer :manager_id

      t.timestamps
    end
  end
end
