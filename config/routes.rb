Rails.application.routes.draw do
  namespace :admin do
    resources :roles, :except => :show do
      resources :sections, :controller => :role_sections, :only => :none do
        collection do
          post :create
          post :create_rule
        end

        member do
          put :rule_on
          put :rule_off

          delete :destroy
          delete :destroy_rule
        end
      end
    end
  end
end