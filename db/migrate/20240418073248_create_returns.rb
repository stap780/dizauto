class CreateReturns < ActiveRecord::Migration[7.1]
  def change
    create_table :returns do |t|
      t.references :client, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.string :number
      t.references :return_status, null: false, foreign_key: true
      t.references :invoice, null: false, foreign_key: true

      t.timestamps
    end
  end
end
