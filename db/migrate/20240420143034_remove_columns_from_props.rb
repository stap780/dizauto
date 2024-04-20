class RemoveColumnsFromProps < ActiveRecord::Migration[7.1]
  def change
    remove_column :props, :product_id
    remove_column :props, :detal_id
  end
end
