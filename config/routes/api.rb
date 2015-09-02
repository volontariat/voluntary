namespace :voluntary, path: 'api', module: 'voluntary/api', defaults: {format: 'json'} do
  namespace :v1 do
    resources :stories, only: [] do
      resources :tasks, only: [:index, :create]
    end
    
    resources :argument_topics, only: [] do
      collection do
        get :autocomplete
      end  
    end
    
    resources :arguments do
      collection do
        get :matrix
      end
    end
    
    get '/things/:left_thing_name/vs/:right_thing_name/arguments', to: 'things/arguments#comparison'
    
    resources :users do
      resources :organizations, only: [:index]
    end
  end
end