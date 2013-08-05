match 'workflow' => 'workflow#index', as: :workflow

namespace 'workflow' do
  resources :project_owner, only: :index do
    collection do
      match 'tasks/:id/edit' => 'tasks#edit', as: :edit_task
    end
  end
  
  resources :user, only: :index do
    collection do    
      match 'products/:id' => 'products#show', as: :product
      match 'products/:product_id/areas/:id' => 'user/product/areas#show', as: :product_area
      
      match 'projects/:id' => 'user/projects#show', as: :user_project
      
      match 'stories/:story_id/tasks' => 'tasks#index', as: :tasks
      match 'stories/:story_id/tasks/next' => 'tasks#next', as: :next_task
      put 'tasks/:id' => 'tasks#update', as: :update_task
      match 'tasks/:id/edit' => 'tasks#edit', as: :edit_task
          
      match 'tasks/:id/assign' => 'tasks#assign', as: :assign_task
      match 'tasks/:id/review' => 'tasks#review', as: :review_task
      match 'tasks/:id/unassign' => 'tasks#unassign', as: :unassign_task
      match 'tasks/:id/complete' => 'tasks#complete', as: :complete_task
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
      match '/' => 'candidatures#new', as: :new
       
      get :autocomplete 
       
      get :new
      get :accepted
      get :denied
    end
  end
end