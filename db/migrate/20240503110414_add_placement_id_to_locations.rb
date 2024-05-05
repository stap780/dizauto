class AddPlacementIdToLocations < ActiveRecord::Migration[7.1]
  def change
    add_reference :locations, :placement, foreign_key: true
  end
end
