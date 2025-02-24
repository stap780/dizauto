json.extract! avito, :id, :title, :api_id, :api_secret, :created_at, :updated_at
json.url avito_url(avito, format: :json)
