class Workflow::UserController < ApplicationController
  def index
    @assigned_tasks = Task.where(user_id: current_user.id, state: 'assigned')
    @completed_tasks = Task.complete.where(user_id: current_user.id)
    @sidenav_links_count = 1
  end
end