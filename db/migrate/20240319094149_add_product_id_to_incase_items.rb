class AddProductIdToIncaseItems < ActiveRecord::Migration[7.1]
  def change
    add_column :incase_items, :product_id, :integer
  end
end
