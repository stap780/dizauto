json.extract! shipping, :id, :name, :phone, :address, :date, :time_from, :time_to, :order_id, :created_at, :updated_at
json.url shipping_url(shipping, format: :json)
