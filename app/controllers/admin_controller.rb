class AdminController < ApplicationController
  def sync_songs
    songs_data = JSON.parse(params[:songs_json])
    
    count = 0
    songs_data.each do |data|
      unless Song.exists?(filename: data['filename'])
        Song.create!(
          title: data['title'],
          filename: data['filename'],
          duration_seconds: data['duration_seconds'],
          year: data['year'],
          notes: data['notes']
        )
        count += 1
      end
    end
    
    render json: { success: true, imported: count }
  end
end