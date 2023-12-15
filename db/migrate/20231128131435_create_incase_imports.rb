class CreateIncaseImports < ActiveRecord::Migration[7.0]
  def change
    create_table :incase_imports do |t|
      t.boolean :active
      t.string :title
      t.string :report
      t.string :file
      t.string :uniq_field

      t.timestamps
    end
  end
end
