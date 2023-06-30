Editus::Engine.routes.draw do
  root "home#index"

  get "manual_update", to: "home#manual_update"
  get "scripts", to: "home#scripts"
  post "/update", to: "home#update", as: :update
  post "validate", to: "home#validate", as: :validate

  post "scripts/:id/run", to: "home#run_script", as: :run
  post "undo/:id", to: "home#undo", as: :undo
end
