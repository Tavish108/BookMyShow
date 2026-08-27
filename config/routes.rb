Rails.application.routes.draw do
  get "seats/index"
  get "seats/show"
  get "seats/new"
  get "seats/edit"
  get "auditoriums/index"
  get "auditoriums/show"
  get "auditoriums/new"
  get "auditoriums/edit"
  get "theatres/index"
  get "theatres/show"
  get "theatres/new"
  get "theatres/edit"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :theatres do
    resources :auditoriums do
      resources :seats
    end
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
