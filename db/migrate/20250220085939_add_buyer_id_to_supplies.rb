class AddBuyerIdToSupplies < ActiveRecord::Migration[7.1]
  def change
    add_column :supplies, :buyer_id, :integer
  end
end
