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

#HAS 20140112 very friendly urls ...
  get 'ivellio', to: '/pages/ivellio'
  get 'team', to: '/pages/team'
  get 'services', to: '/pages/ivellio'
  get 'contact', to: '/pages/contact'

end