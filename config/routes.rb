Rails.application.routes.draw do

  root 'gramercy/meta/contexts#index'

  resources :parsers
  namespace :is_a do
    resources :categories
  end
  namespace :gramercy do
    namespace :meta do
      resources :contexts
      resources :roots
    end
    namespace :part_of_speech do
      resources :generics
    end
  end

end
