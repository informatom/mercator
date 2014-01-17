Mercator::Application.routes.draw do
  match ENV['RAILS_RELATIVE_URL_ROOT'] => 'front#index' if ENV['RAILS_RELATIVE_URL_ROOT']

  mount Ckeditor::Engine => '/ckeditor'

  root :to => 'front#index'
  get 'admin' => 'admin/front#index', :as => 'admin_front'
  get 'contracting' => 'contracting/front#index', :as => 'contracting_front'
  get 'sales' => 'sales/front#index', :as => 'sales_front'

  namespace :contracting do
    resources :toners do
      collection do
        get 'upload'
        post 'do_upload'
      end
    end
  end

  namespace :admin do
    resources :page_templates do
      collection do
        post 'restart'
      end
    end
  end

  get 'users/:id/reset_password_from_email/:key' => 'users#reset_password', :as => 'reset_password_from_email'
  get 'users/:id/accept_invitation_from_email/:key' => 'users#accept_invitation', :as => 'accept_invitation_from_email'
  get 'users/:id/activate_from_email/:key' => 'users#activate', :as => 'activate_from_email'

  post 'search' => 'front#search', :as => 'site_search_post'
  get 'search' => 'front#search', :as => 'site_search'

  post 'categories/sort' => 'categories#sort'

  get 'users/:user_id/billing_addresses/new' => 'billing_addresses#new_for_user', :as => 'new_user_billing_address'
  get 'users/:user_id/billing_addresses' => 'billing_addresses#index_for_user', :as => 'user_billing_addresses'
  post 'users/:user_id/billing_addresses' => 'billing_addresses#create_for_user'

  get 'users/:user_id/orders' => 'orders#index_for_user', :as => 'user_orders'
end