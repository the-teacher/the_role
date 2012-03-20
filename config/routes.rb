Rails.application.routes.draw do
  namespace :admin do
    resources :roles do

      collection do
        get  :new
        get  :index
        post :new_section
        post :new_rule
      end

      resources :sections, :controller => :role_section do
        member do
          get    :new_rule
          delete :delete_rule
        end
      end

    end
  end
end