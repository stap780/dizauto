class RemoveProductIdFromPlaces < ActiveRecord::Migration[7.1]
  def change
    remove_column :places, :product_id
  end
end
