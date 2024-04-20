json.extract! invoice_item, :id, :product_id, :price, :discount, :sum, :quantity, :vat, :invoice_id, :created_at, :updated_at
json.url invoice_item_url(invoice_item, format: :json)
