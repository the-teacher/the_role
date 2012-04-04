Rails.application.routes.draw do
  namespace :admin do
    resources :roles do
      resources :sections, :controller => :role_sections, :only => :none do
        member do
          post   :create
          post   :create_rule
          delete :destroy
          delete :destroy_rule
        end
      end
    end
  end
end