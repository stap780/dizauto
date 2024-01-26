class AddIndexToProps < ActiveRecord::Migration[7.1]
  def change
    add_index :props, :property_id
    add_index :props, :characteristic_id
  end
end
