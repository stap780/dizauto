class AddCompanyIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :company, foreign_key: true
  end
end
