Rails.application.routes.draw do
# Routes normales
  get 'player/album/:id', to: 'player#album', as: 'player_album'
  get 'player/radio', to: 'player#radio', as: 'player_radio'

  # Routes embed (iframe)
  get 'embed/album/:id', to: 'player#album_embed', as: 'embed_album'
  get 'embed/radio', to: 'player#radio_embed', as: 'embed_radio'
 
  resources :albums
  resources :songs do
    collection do
      get :search
    end
  end

end
