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

      delete '/employee/:id' => :remove_employee, as: :employee_remove
    end
  end
  get '/account/entries/:id' => "entries#show"
  get '/account/folders/:id' => "folders#show"
  

  namespace :auth do
    post :signin, :signout, :forgot
  end


  resources :users, only: :update do
    member { post :signin }
  end
  resources :companies, only: %i(create update)
  resources :entries, only: %i(index show destroy) do
    resources :comments, only: %i(create update)
  end
  resources :searches, only: %i(create update destroy) do
    member { post "blacklist/:entry_id" => :blacklist }
  end
  resources :folders, only: %i(show create update destroy) do
    member { put :add_entry, :remove_entry }
  end


  namespace :admin do
    scope controller: :home do
      root to: :index, as: ''
      get :dictionaries
    end
    resources :proposals, only: %i(index show update)
    resources :industries, :areas, :keyword_groups, only: %i(create update destroy), defaults: { format: :json }
    resources :sources, only: %i(index update)
    resources :entries, only: :index
  end

end
