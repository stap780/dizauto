json.extract! invoice_status, :id, :title, :color, :position, :created_at, :updated_at
json.url invoice_status_url(invoice_status, format: :json)
