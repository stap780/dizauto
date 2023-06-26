json.extract! line_item, :id, :incase_id, :title, :quantity, :katnumber, :price, :sum, :status, :created_at, :updated_at
json.url line_item_url(line_item, format: :json)
