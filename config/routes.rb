PostitTemplate::Application.routes.draw do
  root to: 'posts#index'

  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  post '/webhooks/github', to: 'github_webhooks#deploy'

  resources :posts, except: :destroy do
    member do
      post 'votes', to: :vote
    end
    resources :comments, only: [:create] do
      member do
        post 'votes', to: :vote
      end
    end
  end
  resources :categories, only: [:new, :create, :show]
  resources :users, only: [:create, :show, :edit, :update]
end
