class HomeController < ApplicationController
  def index
    @songs_count   = Song.count
    @albums_count  = Album.count
    @albums_linked = Album.where.not(web_link: [nil, ""]).count
  end
end