class CorrectLocationsPlacementsRelation < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key "locations", "placements"

    remove_column :locations, :placement_id

    add_reference :locations, :placement
  end
end
