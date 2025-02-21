class AddSellerIdToReturns < ActiveRecord::Migration[7.1]
  def change
    add_column :returns, :seller_id, :integer
  end
end
