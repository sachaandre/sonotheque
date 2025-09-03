json.extract! song, :id, :title, :filename, :duration_seconds, :year, :play_count, :notes, :created_at, :updated_at
json.url song_url(song, format: :json)
