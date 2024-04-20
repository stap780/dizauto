json.extract! invoice, :id, :company_id, :number, :invoice_status_id, :order_id, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
