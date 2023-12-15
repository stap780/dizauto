class CreateIncases < ActiveRecord::Migration[7.0]
  def change
    create_table :incases do |t|
      t.string :region
      t.integer :strah_id
      t.string :stoanumber
      t.string :unumber
      t.integer :company_id
      t.string :carnumber
      t.datetime :date
      t.string :modelauto
      t.decimal :totalsum, precision: 12, scale: 2
      t.string :status
      t.string :tip

      t.timestamps
    end
  end
end
