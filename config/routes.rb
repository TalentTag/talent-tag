TalentTag::Application.routes.draw do

  root "promo#index"

  resources :users
  resources :companies

end
