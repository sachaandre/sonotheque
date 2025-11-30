class RemoveUniqueIndexFromAlbumSongs < ActiveRecord::Migration[8.0]
  def change
    remove_index :album_songs, [:album_id, :track_number]
    add_index :album_songs, [:album_id, :track_number] # Sans unique: true
  end
end