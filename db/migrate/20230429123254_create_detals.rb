class CreateDetals < ActiveRecord::Migration[7.0]
  def change
    create_table :detals do |t|
      t.string :sku
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
