class RemoveForeignKeys < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key "enter_items", "products"
    remove_foreign_key "invoice_items", "products"
    remove_foreign_key "locations", "products"
    remove_foreign_key "loss_items", "products"
    remove_foreign_key "return_items", "products"
    remove_foreign_key "stock_transfer_items", "products"
    remove_foreign_key "stocks", "products"
  end
end
