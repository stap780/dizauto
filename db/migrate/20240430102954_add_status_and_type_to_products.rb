class AddStatusAndTypeToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :status, :string, null: false, default: "draft"
    add_column :products, :tip, :string, null: false, default: "product"
  end
end
