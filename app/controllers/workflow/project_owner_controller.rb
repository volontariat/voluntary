class Workflow::ProjectOwnerController < ApplicationController
  @@extra_tabs = []
  @@tabs_data = []
  
  def self.extra_tabs
    @@extra_tabs
  end
  
  def self.tabs_data
    @@tabs_data
  end
  
  def self.add_tabs_data(tabs, code)
    @@extra_tabs += tabs
    @@tabs_data << code
  end
  
  def index
    @stories = {}
    @tasks = {}
    
    Workflow::ProjectOwnerController.tabs_data.each {|code| instance_exec &code }
    
    { stories: [:completed, :active], tasks: [:under_supervision] }.each do |controller, states|
      states.each do |state|
        collection = controller.to_s.classify.constantize.where(
          offeror_id: current_user.id, state: state
        ).limit(5)
        eval("@#{controller}[state] = collection")
      end
    end
    
    @twitter_sidenav_level = 2
  end
end