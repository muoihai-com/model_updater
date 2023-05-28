Rails.application.routes.draw do
  mount ModelUpdater::Engine => "/model_updater"
end
