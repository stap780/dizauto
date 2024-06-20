json.extract! stock_transfer_item, :id, :product_id, :quantity, :price, :vat, :sum, :created_at, :updated_at
json.url stock_transfer_item_url(stock_transfer_item, format: :json)
