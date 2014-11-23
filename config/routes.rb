TalentTag::Application.routes.draw do

  root to: "account#index", as: :account
  scope controller: :public do
    get :promo, :about, :contacts, :faq, :features, :media, :blog
    get '/blog/post:id' => 'public#blog', as: :blog_post
  end


  scope controller: :public do
    get '/password/:token' => :edit_password, as: :edit_password
    put '/password/:token' => :update_password, as: :update_password

    scope :invites do
      get  '/:company_id/:code' => :add_employee, as: :add_employee
      post '/:company_id/:code' => :create_employee, as: :create_employee
    end

    get :add_company
    get :excerpts
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
  end


  resources :users, only: %i(create update) do
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


  namespace :admin do
    scope controller: :home do
      root to: :index, as: ''
      get :dictionaries
    end
    resources :proposals, only: %i(index show update)
    resources :industries, :areas, :keyword_groups, only: %i(create update destroy), defaults: { format: :json }
    resources :sources, only: %i(index update)
    resources :entries, only: :index do
      collection { get :deleted }
      member { put :delete, :restore }
    end
    resources :media, except: :show
    namespace :stats do
      get '/entries/:year(/sources/:source_id)' => :entries, as: :entries
    end
  end

end
