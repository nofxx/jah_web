ActionController::Routing::Routes.draw do |map|

  # Root home controller
  map.root :controller => 'home', :action => 'index'

  map.status "status", :controller => 'home', :action => 'status'
  map.config "config", :controller => 'home', :action => 'config'
  map.history "history", :controller => 'history', :action => 'index'

  map.resources :hosts, :member => {
    :ping => :post,
    :switch => :put,
    :wipe => :put
  } do |host|
    host.resources :proks
    host.resources :evs
  end


  map.resources :evs , :member => {:redo => :post }
  map.resources :groups
  map.resources :users

 #  map.connect ':controller/:action/:id'
 #  map.connect ':controller/:action/:id.:format'
end
