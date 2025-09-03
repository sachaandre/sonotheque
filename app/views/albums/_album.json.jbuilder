json.extract! album, :id, :name, :description, :web_link, :year, :created_at, :updated_at
json.url album_url(album, format: :json)
