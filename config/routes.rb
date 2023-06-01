ModelUpdater::Engine.routes.draw do
  root "home#index"

  get "manual_update", to: "home#manual_update"
  get "scripts", to: "home#scripts"
  post "/update", to: "home#update", as: :update
end
