json.extract! client, :id, :surname, :name, :middlename, :phone, :email, :created_at, :updated_at
json.url client_url(client, format: :json)
