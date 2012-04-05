Rails.application.routes.draw do
  namespace :admin do
    resources :roles do
      resources :sections, :controller => :role_sections, :only => :none do
        collection do
          post :create
          post :create_rule
        end
        member do
          delete :destroy
          delete :destroy_rule
        end
      end
    end
  end
end