json.extract! inventory_status, :id, :title, :color, :position, :created_at, :updated_at
json.url inventory_status_url(inventory_status, format: :json)
