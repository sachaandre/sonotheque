class PlayerController < ApplicationController
  skip_before_action :require_authentication
  before_action :set_iframe_headers, only: [:radio_embed, :album_embed, :radio, :album]

  def album
    @album = Album.find(params[:id])
    @songs = @album.album_songs.order(:track_number)
                   .includes(song: [:albums, { audio_file_attachment: :blob }])
                   .map(&:song)
  end

  def radio
    @songs_json = radio_songs_json
  end

  def album_embed
    @album = Album.find(params[:id])
    @songs = @album.album_songs.order(:track_number)
                   .includes(song: [:albums, { audio_file_attachment: :blob }])
                   .map(&:song)
    render :album, layout: 'player'
  end

  def radio_embed
    @songs_json = radio_songs_json
    render :radio, layout: 'player'
  end

  private

  def radio_songs_json
    cache_key = [
      "radio_songs_v2",
      Song.count,
      Song.maximum(:updated_at),
      Album.maximum(:updated_at),
      AlbumSong.maximum(:updated_at)
    ]
    Rails.cache.fetch(cache_key) do
      Song.with_attached_audio_file
          .includes(:albums)
          .to_json(only: [:id, :title], methods: [:audio_url, :album_web_link, :album_name, :album_author])
    end
  end

  def set_iframe_headers
    response.headers['X-Frame-Options'] = 'ALLOWALL'
  end
end