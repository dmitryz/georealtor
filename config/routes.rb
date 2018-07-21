Rails.application.routes.draw do
  namespace :estimate do
    resources :addresses do
      get 'search', on: :collection
    end
  end
end
