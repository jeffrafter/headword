ActionController::Routing::Routes.draw do |map|
  map.username ':username', :controller => 'headword/users', :action => 'show'    
end
