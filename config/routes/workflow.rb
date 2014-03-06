get 'workflow' => 'workflow#index', as: :workflow

namespace 'workflow' do
  resources :project_owner, only: :index do
    collection do
      match 'tasks/:id/edit' => 'tasks#edit', as: :edit_task
    end
  end
  
  resources :user, only: :index do
    collection do    
      get 'products/:id' => 'products#show', as: :product
      get 'products/:product_id/areas/:id' => 'user/product/areas#show', as: :product_area
      
      get 'projects/:id' => 'user/projects#show', as: :user_project
      
      get 'stories/:story_id/tasks' => 'tasks#index', as: :tasks
      get 'stories/:story_id/tasks/next' => 'tasks#next', as: :next_task
      put 'tasks/:id' => 'tasks#update', as: :update_task
      get 'tasks/:id/edit' => 'tasks#edit', as: :edit_task
          
      get 'tasks/:id/assign' => 'tasks#assign', as: :assign_task
      get 'tasks/:id/review' => 'tasks#review', as: :review_task
      get 'tasks/:id/unassign' => 'tasks#unassign', as: :unassign_task
      get 'tasks/:id/complete' => 'tasks#complete', as: :complete_task
    end
  end
  
  resources :vacancies, controller: 'vacancies', only: :index do
    collection do
      match '/' => 'vacancies#open', as: :open
      
      get :autocomplete
      
      get :open
      get :recommended
      get :denied
      get :closed
    end
  end
  
  resources :candidatures, controller: 'candidatures', only: :index do
    collection do
      get '/' => 'candidatures#new', as: :new
       
      get :autocomplete 
       
      get :new
      get :accepted
      get :denied
    end
  end
end