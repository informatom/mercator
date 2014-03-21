ActionController::Routing::Routes.draw do |map|
  map.cross_selling "/categories/verbrauchsmaterial", :controller => 'cross_selling', :action => :show, :method => :get
  map.select_cross_selling "/categories/verbrauchsmaterial/:action", :controller => 'cross_selling'
 end
