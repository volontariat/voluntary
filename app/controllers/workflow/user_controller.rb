class Workflow::UserController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @hide_sidebar = true
  end
end