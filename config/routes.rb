Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :answers_requests
    end
  end
  namespace :api do
    namespace :v1 do
      resources :requests
    end
  end
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: {format: :json} do
    namespace :v1 do 
      devise_scope :user do
        post "sign_up", to: "registrations#create"
        post "sign_up_donor", to: "registrations#create_donor"
        post "sign_in", to: "sessions#create"
        get "user/:id", to: "users#show"
        put "user/:id", to: "users#update"
      end
      resources :donors
      put "donor_update/:id", to: "api/v1/donors#update"
      get "donors_all", to: "public#index_donors"
      get "current_u",to:"public#current_u"
    end
  end
end
