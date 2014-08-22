Mercator::Application.routes.draw do
  match ENV['RAILS_RELATIVE_URL_ROOT'] => 'front#index' if ENV['RAILS_RELATIVE_URL_ROOT']

  mount Ckeditor::Engine => '/ckeditor'

  if Rails.env.production?
    mount MercatorMesonic::Engine => "/mercator_mesonic"
    mount MercatorIcecat::Engine => "/mercator_icecat"
    mount MercatorBechlem::Engine => "/"
    mount MercatorLegacyImporter::Engine => "/mercator_legacy_importer"
    mount MercatorMpay24::Engine => "/mercator_mpay24"
  end

  root :to => 'front#home'
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
  get 'switch(.:format)' => 'users#switch', :as => 'user_switch'

  post 'request_login_link(.:format)' => 'users#request_email_login', :as => 'request_email_login'

  post 'search' => 'front#search', :as => 'site_search_post'
  get 'search' => 'front#search', :as => 'site_search'

  post 'categories/sort' => 'categories#sort'
  post 'conversations/refresh' => 'conversations#refresh'
  post 'offers/refresh' => 'offers#refresh'
  post 'orders/refresh' => 'orders#refresh'
  post 'sales/conversations/refresh' => 'sales/conversations#refresh'
  post 'sales/refresh' => 'sales/front#refresh'
  post 'sales' => 'sales/front#index'
  post 'sales/conversations/:id/do_upload' => 'sales/conversations#do_upload'


  post 'login(.:format)' => 'users#login'
  get 'login(.:format)' => 'users#login'
  get 'logout(.:format)' => 'users#logout'
  get 'forgot_password(.:format)' => 'users#forgot_password'
  post 'forgot_password(.:format)' => 'users#forgot_password'
  get ':id' => 'webpages#show', :as => 'webpage_in_root'
end