class RemoveInsidFromVariants < ActiveRecord::Migration[7.1]
  def change
    remove_column :variants, :insid
  end
end
