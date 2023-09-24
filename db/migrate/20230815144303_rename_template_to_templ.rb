class RenameTemplateToTempl < ActiveRecord::Migration[7.0]
  def change
    rename_table :templates, :templs
  end
end
