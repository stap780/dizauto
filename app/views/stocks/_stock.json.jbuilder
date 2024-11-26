json.extract! stock, :id, :variant_id, :user_id, :stockable_id, :stockable_type, :move, :value, :created_at, :updated_at
json.url stock_url(stock, format: :json)
