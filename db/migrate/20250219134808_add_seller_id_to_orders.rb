class AddSellerIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :seller_id, :integer
  end
end
