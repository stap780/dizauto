class CreateAvitos < ActiveRecord::Migration[7.1]
  def change
    create_table :avitos do |t|
      t.string :title
      t.string :api_id
      t.string :api_secret

      t.timestamps
    end
  end
end
