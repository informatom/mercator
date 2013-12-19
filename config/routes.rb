Mercator::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  match ENV['RAILS_RELATIVE_URL_ROOT'] => 'front#index' if ENV['RAILS_RELATIVE_URL_ROOT']

  root :to => 'front#index'
  match 'admin' => 'admin/front#index', :as => 'admin_front'
  match 'contracting' => 'contracting/front#index', :as => 'contracting_front'
  match 'search' => 'admin/front#search', :as => 'site_search'

  namespace :contracting do
    resources :toners do
      collection do
        get 'upload'
        post 'do_upload'
      end
    end
  end

  match 'users/:id/reset_password_from_email/:key' => 'users#reset_password', :as => 'reset_password_from_email'
  match 'users/:id/accept_invitation_from_email/:key' => 'users#accept_invitation', :as => 'accept_invitation_from_email'
  match 'users/:id/activate_from_email/:key' => 'users#activate', :as => 'activate_from_email'
  match 'search' => 'front#search', :as => 'site_search'

  post 'categories/sort' => 'categories#sort'
end