class VolontariatSeed < DbSeed
  USER_ROLES = {
    master: {},
    admin: {},
    project_owner: {},
    user: {}
  }
  
  def create_fixtures
    super
    
    create_areas
    
    # should send notifications to stream and email
  end
  
  private
  
  def create_areas
    Area.create!(
      [ 
        { name: 'General' },
        { name: 'Software Engineering' }
      ]
    )
  end
end