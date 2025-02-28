class CreateMitupais < ActiveRecord::Migration[7.1]
  def change
    create_table :mitupais do |t|
      t.string :api_url
      t.string :api_key

      t.timestamps
    end
  end
end
