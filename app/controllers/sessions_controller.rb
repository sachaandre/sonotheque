class SessionsController < ApplicationController
  def new
  end

  def create
    if params[:password] == ENV['APP_PASSWORD']
      session[:authenticated] = true
      redirect_to root_path, notice: "Authentifié !"
    else
      redirect_to login_path, alert: "Mot de passe incorrect"
    end
  end

  def destroy
    session[:authenticated] = false
    redirect_to login_path
  end
end
