class CreateDetalProps < ActiveRecord::Migration[7.1]
  def change
    create_table :detal_props do |t|
      t.references :property, null: false, foreign_key: true
      t.references :characteristic, null: false, foreign_key: true
      t.references :detal, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
