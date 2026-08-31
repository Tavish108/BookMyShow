Rails.application.routes.draw do
resources :movies
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  
  get "/register", to: "users#new"
  post "/register", to: "users#create"


  get "/login", to: "sessions#new"
 post "/login", to: "sessions#create"

 delete "/logout", to: "sessions#destroy"

  get "/me", to: "users#me"


  get "/admin", to: "admin#index"

 get "/dashboard", to: "dashboards#user", as: :user_dashboard

get "/dashboard/theatre-admin",
    to: "dashboards#theatre_admin",
    as: :theatre_admin_dashboard

get "/dashboard/content-admin",
    to: "dashboards#content_admin",
    as: :content_admin_dashboard

get "/dashboard/super-admin",
    to: "dashboards#super_admin",
    as: :super_admin_dashboard


  root "home#index"

    resources :theatres do
    resources :auditoriums do
      resources :seats
    end
  end

end
