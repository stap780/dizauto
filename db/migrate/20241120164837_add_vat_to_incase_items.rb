class AddVatToIncaseItems < ActiveRecord::Migration[7.1]
  def change
    add_column :incase_items, :vat, :integer
  end
end
