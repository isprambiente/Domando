Rails.application.routes.draw do
  resources :faqs
  get '/notallowed', to: redirect('notallowed.html'), as: :notallowed
  get '/faqs/:text', to: 'home#search' #, constraints: { text: /[^\W]+/ }
  get '/link/:text', to: 'home#search_by_title', as: :search_by_title #, constraints: { text: /[^\W]+/ }
  localized do
    # Admin's routes
    scope :admin do
      resources :users do
        get :list, on: :collection, to: 'users#list'
        patch :unlock, on: :member, to: 'users#unlock'
        delete :trash, on: :member, to: 'users#trash'
      end
      resources :faqs do
        get :list, on: :collection, to: 'faqs#list'
      end
    end
    resources :home, only: %i[index show] do
      get :list, on: :collection, to: 'home#list'
      get :favorite, on: :collection, to: 'home#favorite'
      get :list_favorite, on: :collection, to: 'home#favorite_list'
      get :propose, on: :collection, to: 'home#propose'
      post :proposed, on: :collection, to: 'home#propose_send'
      put ':id', on: :collection, to: 'home#favorite_create', as: :favorite_create
      delete ':id', on: :collection, to: 'home#favorite_destroy', as: :favorite_destroy
    end
    devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout' }
    root 'home#index'
  end
end
