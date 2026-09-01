Rails.application.routes.draw do

  resources :movies


  # Authentication

  get "/register",
      to: "users#new"

  post "/register",
       to: "users#create"


  get "/login",
      to: "sessions#new"

  post "/login",
       to: "sessions#create"


  delete "/logout",
         to: "sessions#destroy"


  get "/me",
      to: "users#me"


  # Admin

  get "/admin",
      to: "admin#index"


  # Dashboards

  get "/dashboard",
      to: "dashboards#user",
      as: :user_dashboard


  get "/dashboard/theatre-admin",
      to: "dashboards#theatre_admin",
      as: :theatre_admin_dashboard


  get "/dashboard/content-admin",
      to: "dashboards#content_admin",
      as: :content_admin_dashboard


  get "/dashboard/super-admin",
      to: "dashboards#super_admin",
      as: :super_admin_dashboard


  # Admin users

  namespace :admin do

    resources :users,
              only: [:index, :edit, :update]

  end


  # ==========================
  # BOOKINGS
  # ==========================

resources :bookings, only: [:show, :create] do
  resource :payment, only: [:new, :create]
end


  # Seat selection page

  get "/shows/:show_id/book",
      to: "bookings#new",
      as: :new_booking


  # Create booking

  post "/shows/:show_id/book",
       to: "bookings#create",
       as: :create_booking


  # ==========================
  # THEATRES
  # ==========================

  resources :theatres do

    resources :auditoriums do

      resources :seats

    end

  end


  # Health check

  get "up",
      to: "rails/health#show",
      as: :rails_health_check


  # Home

  root "home#index"

    resources :theatres do
    resources :auditoriums do
      resources :seats do
        collection do
          post :generate
        end
      end
    end
  end

end
