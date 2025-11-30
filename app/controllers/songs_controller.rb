class SongsController < ApplicationController
  before_action :set_song, only: %i[ show edit update destroy ]

  # GET /songs or /songs.json
  def index
    @songs = Song.order(:title).page(params[:page]).per(50)
  end

  # GET /songs/1 or /songs/1.json
  def show
  end

  # GET /songs/new
  def new
    @song = Song.new
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs or /songs.json
  def create
    @song = Song.new(song_params)

    

    respond_to do |format|
      if @song.save
        format.html { redirect_to @song, notice: "Song was successfully created." }
        format.json { render :show, status: :created, location: @song }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1 or /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to @song, notice: "Song was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1 or /songs/1.json
  def destroy
    @song.destroy!

    respond_to do |format|
      format.html { redirect_to songs_path, notice: "Song was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def search
  query = params[:q].to_s.strip
  
    if query.present?
      @songs = Song.where("title ILIKE ?", "%#{query}%")
                  .order(:title)
                  .limit(20)
    else
      @songs = Song.order(:title).limit(20)
    end
  
  render json: @songs.as_json(only: [:id, :title])
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def song_params
      params.expect(song: [ :title, :filename, :duration_seconds, :year, :play_count, :notes, :audio_file ])
    end
end
