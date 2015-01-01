Rails.application.routes.draw do

  root 'gramercy/meta/contexts#index'

  resources :parsers
  resources :part_of_speech
  namespace :gramercy do
    namespace :meta do
      resources :contexts
      resources :roots
    end
  end

end
