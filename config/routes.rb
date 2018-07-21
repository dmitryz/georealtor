# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :estimate do
    resources :addresses do
      get 'search', on: :collection
    end
  end
end
