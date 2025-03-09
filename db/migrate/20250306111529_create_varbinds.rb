class CreateVarbinds < ActiveRecord::Migration[7.1]
  def change
    create_table :varbinds do |t|
      t.references :varbindable, polymorphic: true, null: false
      t.string :value
      t.references :variant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
