class AddIndexToAlbumSongs < ActiveRecord::Migration[8.0]
  def change
    if index_exists?(:album_songs, [:album_id, :track_number], unique: true)
      remove_index :album_songs, [:album_id, :track_number]
      add_index :album_songs, [:album_id, :track_number]
    end
  end
end