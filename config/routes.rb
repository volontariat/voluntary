class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    path = File.expand_path("routes/#{routes_name}.rb", File.dirname(__FILE__))
    
    instance_eval(File.read(path))
  end
end

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'devise_extensions/registrations',
  }

  resources :areas do
    resources :users, only: :index
    resources :projects, only: :index
    
    collection do
      put :update_multiple
      get :autocomplete
    end
  end
  
  resources :professions do
    collection do
      put :update_multiple
      get :autocomplete
    end
  end
  
  resources :products do
    resources :projects, only: [:index, :new]
    
    collection do
      put :update_multiple
      get :autocomplete
    end
  end
  
  resources :projects do
    resources :users, only: :index
    resources :vacancies, only: [:index, :new]
    resources :stories, only: [:index, :new]
    resources :comments, only: [:index, :new]
    
    collection do
      put :update_multiple
      get :autocomplete
    end
  end
      
  resources :vacancies do
    resources :candidatures, only: [:index, :new]
    resources :comments, only: [:index, :new]
    
    collection do
      put :update_multiple
      get :autocomplete
    end
    
    member do
      put :recommend
      put :accept_recommendation
      put :deny_recommendation 
      put :close
      put :reopen
    end
  end
  
  resources :candidatures do
    resources :comments, only: [:index, :new]
    
    collection do
      put :update_multiple
      get :autocomplete
    end
    
    member do
      get :accept
      get :deny
      get :quit
    end
  end
  
  resources :stories, only: [:create, :show, :edit, :update, :destroy] do
    resources :tasks, only: [:index, :new]
    
    collection do
      put :update_multiple
      get :autocomplete
    end
    
    member do
      match 'setup_tasks' => 'stories#setup_tasks', via: [:get, :put]
      match 'activate' => 'stories#activate', via: [:get, :put]
      match 'complete' => 'stories#complete', via: [:get, :put]
    end
  end
  
  resources :tasks do
    resources :results, only: [:index, :new]
    
    collection do
      put :update_multiple
      get :autocomplete
    end
    
    member do
      match 'assign' => 'tasks#assign', via: [:get, :put]
      match 'review' => 'tasks#review', via: [:get, :put]
      match 'unassign' => 'tasks#unassign', via: [:get, :put]
      match 'complete' => 'tasks#complete', via: [:get, :put]
    end
  end
  
  resources :results do
    collection do
      put :update_multiple
      get :autocomplete
    end
  end
  
  resources :comments, only: [:new, :edit, :create, :update, :destroy]
  
  resources :users do
    resources :projects, only: :index
    resources :candidatures, only: :index
    
    collection do
      put :update_multiple
      get :autocomplete
      get :languages
    end
    
    member do
      match 'preferences', via: [:get, :put]
    end
  end
   
  draw :workflow
  
  resources :pages do
    collection do
      put :update_multiple
      get :autocomplete
    end
  end
end
