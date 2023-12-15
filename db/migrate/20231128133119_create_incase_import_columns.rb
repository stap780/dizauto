class CreateIncaseImportColumns < ActiveRecord::Migration[7.0]
  def change
    create_table :incase_import_columns do |t|
      t.integer :incase_import_id
      t.string :column_file
      t.string :column_system

      t.timestamps
    end
  end
end
