class Album < ApplicationRecord
    has_one_attached :cover_image

    has_many :album_songs
    has_many :songs, through: :album_songs

    accepts_nested_attributes_for :album_songs, allow_destroy: true

    after_save :update_songs_notes
  
    private
    
    def update_songs_notes
        return if web_link.blank?
        
        songs.each do |song|
            song.update_column(:notes, web_link)
        end
    end
end
