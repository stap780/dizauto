class RenameTableProdpropsToProps < ActiveRecord::Migration[7.0]
  def change
    rename_table :prodprops, :props
  end
end
