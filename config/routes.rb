Rails.application.routes.draw do
  root to: "static#index"

  # root 'food_trucks#index'

  scope :api do
    scope :v1 do
      resources :food_trucks, only: :index
    end
  end
end
