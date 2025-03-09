class RemoveAvitoidFromVariants < ActiveRecord::Migration[7.1]
  def change
    remove_column :variants, :avitoid
  end
end
