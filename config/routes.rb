Rails.application.routes.draw do

  root 'gramercy/meta/contexts#index'

  namespace :gramercy do
    namespace :meta do
      resources :contexts
      resources :roots
    end
  end

end
