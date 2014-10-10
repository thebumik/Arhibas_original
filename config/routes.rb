ActionController::Routing::Routes.draw do |map|
  # default
  map.root :controller => 'pages', :action => 'home', :locale => 'ro'

  # home frontend's dashboard
  map.home_page '/:locale', :controller => 'pages', :action => 'home', :requirements => { :locale => /(en|ro|ru)/ }

  # ADMIN AREA
  map.admin 'admin', :controller => 'admin'
  map.namespace :admin do |admin|
    admin.resource :user_session
    admin.resource :account, :controller => 'users'

    admin.login 'login', :controller => 'user_sessions', :action => 'new'
    admin.logout 'logout', :controller => 'user_sessions', :action => 'destroy'

    admin.resources :pages, :categories, :projects, :comments

    admin.settings 'settings', :controller => 'settings', :action => 'config'
    admin.settings_reset 'settings/reset', :controller => 'settings', :action => 'reset'

    admin.resources :settings
  end

  map.resources :categories,
    :only => [:index, :show],
    :path_prefix => '/:locale',
    :requirements => { :locale => /(en|ro|ru)/ }

  map.resources :projects,
    :only => [:index, :show],
    :path_prefix => '/:locale',
    :member => { :vote => :post },
    :requirements => { :locale => /(en|ro|ru)/ }
  
  map.comment_project '/:locale/projects/:project_id/comment',
    :controller => 'projects',
    :action => 'comment',
    :requirements => { :locale => /(en|ro|ru)/ }

  map.page '/:locale/:slug', :controller => 'pages', :action => 'show', :requirements => { :locale => /(en|ro|ru)/ }
end
