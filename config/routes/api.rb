namespace :voluntary, path: 'api', module: 'voluntary/api', defaults: {format: 'json'} do
  namespace :v1 do
    resources :stories, only: [] do
      resources :tasks, only: [:index, :create]
    end
  end
end