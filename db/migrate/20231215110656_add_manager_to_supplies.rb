class AddManagerToSupplies < ActiveRecord::Migration[7.0]
  def change
    add_column :supplies, :manager_id, :integer
  end
end
