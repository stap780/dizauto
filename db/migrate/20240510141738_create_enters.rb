class CreateEnters < ActiveRecord::Migration[7.1]
  def change
    create_table :enters do |t|
      t.references :enter_status, null: false, foreign_key: true
      t.string :title
      t.datetime :date
      t.references :warehouse, null: false, foreign_key: true
      t.integer :manager_id, null: false

      t.timestamps
    end
  end
end
