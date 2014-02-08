TalentTag::Application.routes.draw do

  if Rails.env.production?
    get '/account' => "b2c/account#index", constraints: { host: "tagzone.talent-tag.ru" }, as: :account_b2c
  else
    scope :candidates, module: :b2c do
      namespace :account do
        root to: :index, as: :b2c
      end
    end
  end

  scope controller: :public do
    root to: :b2b_promo, as: :b2b_promo
    get '/password/:token' => :edit_password, as: :edit_password
    put '/password/:token' => :update_password, as: :update_password

    scope :invites do
      get  '/:company_id/:code' => :add_employee, as: :add_employee
      post '/:company_id/:code' => :create_employee, as: :create_employee
    end
  end



  namespace :auth do
    post :signin, :signout, :forgot
    get "/:provider/callback" => :callback, as: :proviter_callback
    post "/:provider/signup/:uid" => :from_omniauth, as: :signup_from_omniauth
  end

  resources :users, only: %i(create update) do
    member { post :signin }
  end



  scope module: :b2b do
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
    get '/account/entries/:id' => 'entries#show'
    get '/account/folders/:id' => 'folders#show'

    resources :companies, only: %i(create update) do
      member { put :update_to_premium }
    end

    resources :entries, only: %i(index show destroy) do
      resources :'comments', only: %i(create update)
    end

    resources :searches, only: %i(create update destroy) do
      member { post "blacklist/:entry_id" => :blacklist }
    end
    resources :folders, only: %i(show create update destroy) do
      member { put :add_entry, :remove_entry }
    end
  end



  scope module: :b2c do
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
