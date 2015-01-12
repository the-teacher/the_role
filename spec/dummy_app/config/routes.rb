RailsApp::Application.routes.draw do
  devise_for :users

  concern :the_role, TheRole::AdminRoutes.new

  namespace :admin do
    concerns :the_role
  end

  root :to => 'welcome#index'

  get 'welcome/index'
  get 'welcome/profile'
  get 'autologin' => 'welcome#autologin', :as => :autologin

  put 'users/change_role' => "users#change_role", :as => :change_role

  resources  :users, :only => [:edit, :update]

  resources  :pages do
    collection do
      get :my
      get :manage
    end
  end
end
