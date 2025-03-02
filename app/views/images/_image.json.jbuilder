json.extract! image, :id, :url, :rating, :created_at, :updated_at
json.url image_url(image, format: :json)
