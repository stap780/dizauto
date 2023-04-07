json.extract! product, :id, :sku, :barcode, :title, :description, :quantity, :costprice, :price, :video, :created_at, :updated_at
json.url product_url(product, format: :json)
