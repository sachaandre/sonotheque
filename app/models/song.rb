class Song < ApplicationRecord

    has_one_attached :audio_file
    has_many :album_songs
    has_many :albums, through: :album_songs

    # Validation : un fichier audio est obligatoire
    validates :audio_file, presence: true

    def audio_url
        return nil unless audio_file.attached?
        Rails.application.routes.url_helpers.rails_blob_path(audio_file, only_path: true)
    end

    def album_web_link
        notes
    end

    private
    def extract_duration_if_needed
        
    end
    
end
