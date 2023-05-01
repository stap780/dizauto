class AddColumnDetalIdToProps < ActiveRecord::Migration[7.0]
  def change
    add_column :props, :detal_id, :integer
  end
end
