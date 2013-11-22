Mercator::Application.routes.draw do
  match 'admin' => 'admin/front#index', :as => 'admin_front'
  match 'search' => 'admin/front#search', :as => 'site_search'

  mount Ckeditor::Engine => '/ckeditor'

  match ENV['RAILS_RELATIVE_URL_ROOT'] => 'front#index' if ENV['RAILS_RELATIVE_URL_ROOT']

  root :to => 'front#index'

  match 'users/:id/reset_password_from_email/:key' => 'users#reset_password', :as => 'reset_password_from_email'
  match 'users/:id/accept_invitation_from_email/:key' => 'users#accept_invitation', :as => 'accept_invitation_from_email'
  match 'users/:id/activate_from_email/:key' => 'users#activate', :as => 'activate_from_email'

  match 'search' => 'front#search', :as => 'site_search'

  post 'categories/sort' => 'categories#sort'
end