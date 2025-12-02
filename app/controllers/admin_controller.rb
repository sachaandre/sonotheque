class AdminController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:sync_songs]

  # Dans admin_controller.rb
    def reset_songs
    Song.destroy_all
    render json: { success: true, message: "All songs deleted" }
    end
  
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