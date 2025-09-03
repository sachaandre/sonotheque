class AddIndexToAlbumSongs < ActiveRecord::Migration[8.0]
  def change
    add_index :album_songs, [:album_id, :track_number], unique: true
    add_index :album_songs, [:album_id, :song_id], unique: true
  end
end
