Rails.application.routes.draw do
  resources :movies
  resources :shows
  resources :tickets, only: [ :show ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.



  get "/register", to: "users#new"
  post "/register", to: "users#create"
  
  get "/register/verify",
    to: "users#verify_registration",
    as: :verify_registration

post "/register/verify",
     to: "users#complete_registration_verification"





  get "/login",
      to: "sessions#new"

  post "/login",
       to: "sessions#create"


 get "/forgot-password",
    to: "password_resets#new",
    as: :forgot_password

post "/forgot-password",
     to: "password_resets#create"

get "/forgot-password/verify",
    to: "password_resets#verify",
    as: :verify_password_reset

post "/forgot-password/verify",
     to: "password_resets#verify_otp"

get "/reset-password",
    to: "password_resets#edit",
    as: :reset_password

patch "/reset-password",
      to: "password_resets#update"




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
              only: [ :index, :edit, :update ]
  end


# ==========================
# BOOKINGS
# ==========================

resources :bookings, only: [ :show, :create ] do
  resource :payment, only: [ :new, :create ]
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
    get :sales_record, on: :member

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
