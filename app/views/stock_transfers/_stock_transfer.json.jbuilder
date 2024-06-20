json.extract! stock_transfer, :id, :stock_transfer_status_id, :origin_warehouse_id, :destination_warehouse_id, :created_at, :updated_at
json.url stock_transfer_url(stock_transfer, format: :json)
