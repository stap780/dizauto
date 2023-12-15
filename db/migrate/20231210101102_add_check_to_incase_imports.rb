class AddCheckToIncaseImports < ActiveRecord::Migration[7.0]
  def change
    add_column :incase_imports, :check, :boolean, default: false
  end
end
