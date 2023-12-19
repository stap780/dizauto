class AddPositionToOkrugs < ActiveRecord::Migration[7.0]
  def change
    add_column :okrugs, :position, :integer
  end
end
