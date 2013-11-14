# This is an auto-generated file: don't edit!
# You can add your own routes in the config/routes.rb file
# which will override the routes in this file.

Mercator::Application.routes.draw do


  # Resource routes for controller lineitems
  resources :lineitems


  # Resource routes for controller constants
  resources :constants


  # Resource routes for controller categorizations
  resources :categorizations


  # Resource routes for controller addresses
  resources :addresses


  # Resource routes for controller categories
  resources :categories do
    collection do
      get 'treereorder'
      get 'do_treereorder'
    end
    member do
      put 'activate', :action => 'do_activate'
      get 'activate'
      put 'deactivate', :action => 'do_deactivate'
      get 'deactivate'
      put 'reactivate', :action => 'do_reactivate'
      get 'reactivate'
    end
  end


  # Resource routes for controller products
  resources :products do
    member do
      put 'activate', :action => 'do_activate'
      get 'activate'
      put 'announce', :action => 'do_announce'
      get 'announce'
      put 'release', :action => 'do_release'
      get 'release'
      put 'deactivate', :action => 'do_deactivate'
      get 'deactivate'
      put 'reactivate', :action => 'do_reactivate'
      get 'reactivate'
    end
  end


  # Resource routes for controller users
  resources :users do
    collection do
      post 'signup', :action => 'do_signup'
      get 'signup'
    end
    member do
      get 'account'
      put 'reset_password', :action => 'do_reset_password'
      get 'reset_password'
    end
  end

  # User routes for controller users
  match 'login(.:format)' => 'users#login', :as => 'user_login'
  get 'logout(.:format)' => 'users#logout', :as => 'user_logout'
  match 'forgot_password(.:format)' => 'users#forgot_password', :as => 'user_forgot_password'


  # Resource routes for controller property_groups
  resources :property_groups


  # Resource routes for controller properties
  resources :properties


  # Resource routes for controller content_elements
  resources :content_elements

  namespace :ckeditor do

  end

end
