class RemoveColumnsTitleValueFromProdprops < ActiveRecord::Migration[7.0]
  def change
    remove_column :prodprops, :title, :string
    remove_column :prodprops, :value, :string
  end
end
