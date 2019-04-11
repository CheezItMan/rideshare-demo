Rails.application.routes.draw do
  root to: "homepages#index"

  resources :passengers do
    resources :trips, except: [:index, :new, :destroy]
    member do
      post "complete_trip"
    end
  end

  resources :drivers do
    member do
      post "activate"
    end
  end

  resources :trips, only: [:destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
