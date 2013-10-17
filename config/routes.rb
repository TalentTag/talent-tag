TalentTag::Application.routes.draw do

  scope controller: :public do
    root to: :promo
    get '/password/:token' => :edit_password, as: :edit_password
    put '/password/:token' => :update_password, as: :update_password
  end

  namespace :account do
    root to: :index, as: ''
  end

  namespace :auth do
    post :signin, :signout, :forgot
  end


  resources :users
  resources :companies, only: %i(create update)

end
