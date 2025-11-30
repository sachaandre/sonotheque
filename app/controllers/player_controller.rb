class PlayerController < ApplicationController
  def album
    @album = Album.find(params[:id])
    @songs = @album.album_songs.order(:track_number).includes(:song).map(&:song)
  end

  def radio
    @songs = Song.where.not(id: nil).includes(:audio_file_attachment).shuffle
  end

  # Routes embed (avec layout player)
  def album_embed
    @album = Album.find(params[:id])
    @songs = @album.album_songs.order(:track_number).includes(:song).map(&:song)
    render :album, layout: 'player'
  end
  
  def radio_embed
    @songs = Song.all.shuffle
    render :radio, layout: 'player'
  end
end