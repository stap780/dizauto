json.extract! delivery, :id, :order_id, :delivery_type_id, :price, :created_at, :updated_at
json.url delivery_url(delivery, format: :json)
