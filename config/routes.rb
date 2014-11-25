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

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  root :to => 'front#home'
  get 'front' => 'front#index', :as => 'front'
  get 'admin' => 'admin/front#index', :as => 'admin_front'
  get 'contracting' => 'contracting/front#index', :as => 'contracting_front'
  get 'sales' => 'sales/front#index', :as => 'sales_front'
  get 'contentmanager' => 'contentmanager/front#index', :as => 'contentmanager_front'
  get 'productmanager' => 'productmanager/front#index', :as => 'productmanager_front'

  namespace :sales do
    resources :conversations do
      member do
        get 'take'
      end
    end
  end

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

  namespace :productmanager do
    get  'front/show_categorytree' => 'front#show_categorytree'
    get  'front/show_products/:id' => 'front#show_products'
    get  'front/show_category/:id' => 'front#show_category'
    post 'front/update_categories' => 'front#update_categories'

    get    'property_manager/index/:id'                    => 'property_manager#index', :as => 'property_manager'
    get    'property_manager/show_valuetree/:id'           => 'property_manager#show_valuetree'
    get    'property_manager/show_properties'              => 'property_manager#show_properties'
    get    'property_manager/show_property_groups'         => 'property_manager#show_property_groups'
    post   'property_manager/manage_value/:id'             => 'property_manager#manage_value'
    delete 'property_manager/value/:id'                    => 'property_manager#delete_value'
    post   'property_manager/update_property_groups_order' => 'property_manager#update_property_groups_order'
    post   'property_manager/update_properties_order'      => 'property_manager#update_properties_order'

    get    'price_manager/index/:id'            => 'price_manager#index', :as => 'price_manager'
    post   'price_manager/manage_product'       => 'price_manager#manage_product'
    get    'price_manager/show_inventories/:id' => 'price_manager#show_inventories'
    post   'price_manager/manage_inventory'     => 'price_manager#manage_inventory'
    get    'price_manager/show_prices/:id'      => 'price_manager#show_prices'
    post   'price_manager/manage_price'         => 'price_manager#manage_price'
    delete 'price_manager/price/:id'            => 'price_manager#delete_price'
    delete 'price_manager/inventory/:id'        => 'price_manager#delete_inventory'

    get    'relation_manager/index/:id'                  => 'relation_manager#index', :as => 'relation_manager'
    get    'relation_manager/show_products'              => 'relation_manager#show_products'

    get    'relation_manager/show_productrelations/:id' => 'relation_manager#show_productrelations'
    post   'relation_manager/create_productrelation'     => 'relation_manager#create_productrelation'
    delete 'relation_manager/productrelation/:id'        => 'relation_manager#delete_productrelation'

    get    'relation_manager/show_supplyrelations/:id' => 'relation_manager#show_supplyrelations'
    post   'relation_manager/create_supplyrelation'     => 'relation_manager#create_supplyrelation'
    delete 'relation_manager/supplyrelation/:id'        => 'relation_manager#delete_supplyrelation'

    get    'relation_manager/manage_recommendations/:id' => 'relation_manager#manage_recommendations'
    post   'relation_manager/create_recommendation'     => 'relation_manager#create_recommendation'
    delete 'relation_manager/recommendation/:id'        => 'relation_manager#delete_recommendation'

    get    'relation_manager/show_categorizations/:id' => 'relation_manager#show_categorizations'
    get    'relation_manager/show_categorytree'        => 'relation_manager#show_categorytree'
  end

  namespace :contentmanager do
    get  'front/show_foldertree'            => 'front#show_foldertree'
    get  'front/show_webpagestree'          => 'front#show_webpagestree'
    post 'front/update_webpages'            => 'front#update_webpages'
    get  'front/show_webpage/:id'           => 'front#show_webpage'
    get  'front/show_assignments/:id'       => 'front#show_assignments'
    post 'front/update_folders'             => 'front#update_folders'
    get  'front/show_content_elements/:id'  => 'front#show_content_elements'
    get  'front/get_thumbnails/:id'         => 'front#get_thumbnails'
    post 'front/update_page_content_element_assignment/:id' => 'front#update_page_content_element_assignment'
    post 'front/update_content_element/:id' => 'front#update_content_element'
    post 'front/folder'                     => 'front#folder'
    post 'front/delete_folder/:id'          => 'front#delete_folder'
    post 'front/content_element'            => 'front#content_element'
  end

  get 'users/:id/reset_password_from_email/:key' => 'users#reset_password', :as => 'reset_password_from_email'
  get 'users/:id/accept_invitation_from_email/:key' => 'users#accept_invitation', :as => 'accept_invitation_from_email'
  get 'users/:id/activate_from_email/:key' => 'users#activate', :as => 'activate_from_email'
  get 'switch(.:format)' => 'users#switch', :as => 'user_switch'

  post 'request_login_link(.:format)' => 'users#request_email_login', :as => 'request_email_login'

  post 'search' => 'front#search', :as => 'site_search_post'
  get  'search' => 'front#search', :as => 'site_search'

  get 'admin/categories/:id/edit_properties' => 'admin/categories#edit_properties'
  put 'admin/categories/:id/edit_properties' => 'admin/categories#edit_properties'

  post 'conversations/refresh' => 'conversations#refresh'
  post 'offers/refresh' => 'offers#refresh'
  post 'orders/refresh' => 'orders#refresh'
  post 'sales/conversations/refresh' => 'sales/conversations#refresh'
  post 'sales/refresh' => 'sales/front#refresh'
  post 'sales' => 'sales/front#index'
  post 'sales/conversations/:id/do_upload' => 'sales/conversations#do_upload'

  post 'login(.:format)' => 'users#login'
  get  'login(.:format)' => 'users#login'
  get  'logout(.:format)' => 'users#logout'
  get  'forgot_password(.:format)' => 'users#forgot_password'
  post 'forgot_password(.:format)' => 'users#forgot_password'

  get 'categories' => 'categories#index'
  get ':id' => 'webpages#show', :as => 'webpage_in_root'
end