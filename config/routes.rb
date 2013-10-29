TalentTag::Application.routes.draw do

  scope controller: :public do
    root to: :promo
    get '/password/:token' => :edit_password, as: :edit_password
    put '/password/:token' => :update_password, as: :update_password

    scope :invites do
      get  '/:company_id/:code' => :add_employee, as: :add_employee
      post '/:company_id/:code' => :create_employee, as: :create_employee
    end
  end

  namespace :account do
    root to: :index, as: ''
    scope :profile do
      root to: :profile, as: :profile
      put '/' => :update_user

      get :company
      put '/company' => :update_account

      get :employee
      post '/employee' => :add_employee
      # get :signup

      delete '/employee/:id' => :remove_employee, as: :employee_remove
    end
  end

  namespace :auth do
    post :signin, :signout, :forgot
  end


  resources :users, only: :update
  resources :companies, only: %i(create update)

  namespace :admin do
    scope controller: :home do
      root to: :index, as: ''
    end
    resources :proposals, only: %i(index show update)
  end

end
