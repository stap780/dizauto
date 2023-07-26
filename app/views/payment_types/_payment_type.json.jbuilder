json.extract! payment_type, :id, :title, :margin, :desc, :created_at, :updated_at
json.url payment_url(payment_type, format: :json)
