class CreatePlacements < ActiveRecord::Migration[7.1]
  def change
    create_table :placements do |t|
      t.references :warehouse, null: false, foreign_key: true

      t.timestamps
    end
  end
end
