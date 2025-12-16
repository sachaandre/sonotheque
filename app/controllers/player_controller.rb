class PlayerController < ApplicationController
  skip_before_action :require_authentication
  
  before_action :set_iframe_headers, only: [:radio_embed, :album_embed, :radio, :album]

  def album
    @album = Album.find(params[:id])
    @songs = @album.album_songs.order(:track_number).includes(:song).map(&:song)
  end

  def radio
    @songs = Song.where.not(id: nil).shuffle
  end

  def album_embed
    @album = Album.find(params[:id])
    @songs = @album.album_songs.order(:track_number).includes(:song).map(&:song)
    render :album, layout: 'player'
  end
  
  def radio_embed
    @songs = Song.all.shuffle
    render :radio, layout: 'player'
  end

  private

  def set_iframe_headers
    response.headers['X-Frame-Options'] = 'ALLOWALL'
  end
end
