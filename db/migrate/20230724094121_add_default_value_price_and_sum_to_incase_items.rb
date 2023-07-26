class AddDefaultValuePriceAndSumToIncaseItems < ActiveRecord::Migration[7.0]
  def change
    IncaseItem.update_all(price: 0, sum: 0)
    change_column_default :incase_items, :price, from: nil, to: 0
    change_column_default :incase_items, :sum, from: nil, to: 0
  end
end
