class AddIndexToCharacteristicsPropertyId < ActiveRecord::Migration[7.1]
  def change
    add_index :characteristics, :property_id
  end
end
