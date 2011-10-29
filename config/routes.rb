Rails.application.routes.draw do
  namespace :admin do
    resources :roles do
      member do
        get  :new
        get  :index
        post :new_role_section
        post :new_role_policy
      end
      resources :sections, :controller => :role_section do
        member do
          get :new_policy
          delete :delete_policy
        end
      end#sections
    end#policy
  end#admin
end