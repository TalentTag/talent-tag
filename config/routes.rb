TalentTag::Application.routes.draw do

  root to: "account#index", as: :account
  scope controller: :public do
    get :promo, :about, :contacts, :faq, :features, :media, :blog
    scope :features do
      get '/b2b' => :features_b2b, as: :features_b2b
      get '/b2c' => :features_b2c, as: :features_b2c
    end
    get '/blog/post:id' => 'public#blog', as: :blog_post
  end


  scope controller: :public do
    get '/password/:token' => :edit_password, as: :edit_password
    put '/password/:token' => :update_password, as: :update_password

    scope :invites do
      get  '/:company_id/:code' => :add_employee, as: :add_employee
      post '/:company_id/:code' => :create_employee, as: :create_employee
    end

    # get :add_company
  end

  namespace :auth do
    post :signin, :signout, :forgot
    get "/:provider/callback" => :callback, as: :proviter_callback
    post "/:provider/signup/:uid" => :from_omniauth, as: :signup_from_omniauth
  end

  scope :account, controller: :account do
    put '/' => :update
    put '/status' => :update_status
    resources :conversations, only: %i(index show) do
      member { put :touch }
    end
    resources :messages, only: %i(index show create)
    resources :notifications, only: :index do
      collection { post :mark_checked, as: :check }
    end
    get :following
    resources :portfolio, only: %i(create destroy)
  end


  namespace :profile do
    root to: :user, as: ''
    put '/' => :update_user
    put '/avatar' => :update_avatar

    get :company
    put '/company' => :update_account

    get :employee
    post '/employee' => :add_employee
    delete '/employee/:id' => :remove_employee, as: :remove_employee
    delete '/invites/:id' => :remove_invite, as: :remove_invite
  end


  resources :users, only: %i(index create update) do
    collection do
      get :search
      put :add_company, :create_company
    end
    member do
      post :signin
      post :follow
    end
  end


  scope module: :b2b do
    resources :companies, only: %i(show create update)

    resources :entries, only: %i(index show create destroy) do
      resources :comments, only: %i(create update destroy)
    end

    resources :searches, only: %i(create update destroy) do
      member { post "blacklist/:entry_id" => :blacklist }
    end
    resources :folders, only: %i(show create update destroy) do
      member { put :add_entry, :remove_entry }
    end

    scope :profile do
      resources :payments, only: %i(index create) do
        member { put :init, as: :init }
        post :complete
        post :fail
      end
    end
  end


  scope module: :b2c do
    resources :identities, only: :create
    get 'specialists/:id' => 'account#show', as: :specialist
  end


  namespace :hidden do
    get :account
  end


  namespace :admin do
    scope controller: :home do
      root to: :index, as: ''
      get :dictionaries
    end

    resources :locations, only: %i(index create update destroy)

    resources :proposals, only: %i(index show update)

    resources :industries, :areas, :keyword_groups, only: %i(create update destroy), defaults: { format: :json }

    resources :sources, only: %i(index update)

    resources :entries, only: [] do
      collection do
        get '(/:year(/:month(/:day(/:source))))' => :index, as: '', constraints: { year: /\d+/, month: /\d+/, day: /\d+/ }
        get :deleted
      end
      member { put :delete, :restore }
    end

    resources :media, except: :show

    namespace :stats do
      get '/entries/:year(/sources/:source_id)' => :entries, as: :entries
      get :companies, :specialists, :queries
      get '/users/:id/queries' => :scoped_queries, as: :scoped_queries
    end
  end

end
