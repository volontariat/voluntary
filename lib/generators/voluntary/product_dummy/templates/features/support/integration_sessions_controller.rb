class IntegrationSessionsController < ActionController::Base
  def new
    @user_id = params[:user_id]
    render file: File.expand_path('./../integration_sessions_form.html.erb', __FILE__), layout: false
  end
  
  def create
    sign_in_and_redirect User.friendly.find(params[:user_id])
  end
end

#Copypasta from http://openhood.com/rails/rails%203/2010/07/20/add-routes-at-runtime-rails-3/
_routes = nil

begin
  _routes = Dummy::Application.routes
  _routes.disable_clear_and_finalize = true
  _routes.clear!
  
  Dummy::Application.routes_reloader.paths.each{ |path| load(path) }
  
  _routes.draw do
    # here you can add any route you want
    post 'integration_sessions' => 'integration_sessions#create', :as => 'integration_sessions'
    get 'integration_sessions' => 'integration_sessions#new', :as => 'new_integration_sessions'
  end
  
  ActiveSupport.on_load(:action_controller) { _routes.finalize! }
ensure
  _routes.disable_clear_and_finalize = false
end
