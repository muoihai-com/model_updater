ModelUpdater::Engine.routes.draw do
  root 'home#index'
  post '/update', to: 'home#update'
end
