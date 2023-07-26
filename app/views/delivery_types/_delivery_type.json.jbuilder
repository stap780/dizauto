json.extract! delivery_type, :id, :title, :price, :desc, :created_at, :updated_at
json.url delivery_url(delivery_type, format: :json)
