Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'

  namespace :api do
    get 'posts/search/:term', to: 'posts#search', as: 'posts_search'
    resources :posts, only: [:index]
  end
end
