Rails.application.routes.draw do
  # API routing
  scope module: 'api', defaults: {format: 'json'} do
    namespace :v1 do
      # provide the routes for the API here
      get 'investigations', to: 'investigations#index', as: :investigations
      get 'investigations/:id', to: 'investigations#detail', as: :investigations_detail
      post 'investigations/:id/notes', to: 'investigations#new_note', as: :investigations_note
      post 'investigations/:id/add_assignment', to: 'investigations#add_assignment', as: :add_assignment
      put 'end_assignment/:id', to: 'investigations#end_assignment', as: :end_assignment
      put 'drop_suspect/:id', to: 'investigations#drop_suspect', as: :drop_suspect
      get 'crimes', to: 'investigations#crimes', as: :all_crimes
      get 'officers', to: 'investigations#officer_search', as: :search_officers
      get 'criminals', to: 'investigations#criminals_search', as: :search_criminals
      post 'investigations/:id/suspects', to: 'investigations#new_suspect', as: :new_investigation_suspect
      post 'investigations/:id/crime_investigations', to: 'investigations#new_crime_investigation', as: :new_crime_investigation
      put 'investigations/:id', to: 'investigations#update', as: :update_investigation_detail
      delete 'investigations/:id/crimes/:crime_id', to: 'investigations#delete_crime_investigation', as: :delete_investigation_crime

      # Routes for earlier API; disabled for React useage (some overlap)
      # get 'units', to: 'units#index', as: :units
      # get 'criminals/enhanced', to: 'criminals#enhanced', as: :enhanced_criminals
      # get 'officers/:id', to: 'officers#show', as: :officer
      # get 'investigations/:id', to: 'investigations#show', as: :investigation
    
    end
  end

  # Routes for regular HTML views go here...
    # Semi-static page routes

    

    # Authentication routes
    resources :sessions
    get 'login', to: 'sessions#new', as: :login
    post '/login', to: 'sessions#create'
    get '/logout', to: 'sessions#destroy', as: :logout
    delete '/logout', to: 'sessions#destroy'
    

    # Resource routes (maps HTTP verbs to controller actions automatically):
    resources :units
    resources :officers do
      resources :assignments, only: [:new, :create]
    end
    resources :crimes
    resources :criminals
    resources :investigations do
      member do
        patch :close
      end
      resources :investigation_notes, only: [:new, :create], path: 'investigation_notes'
    end
  
    # Routes for assignments
    get 'assignments/new', to: 'assignments#new', as: :new_assignment
    post 'assignments', to: 'assignments#create', as: :assignments
    patch 'assignments/:id/terminate', to: 'assignments#terminate', as: :terminate_assignment

    # Routes for crime_investigations
    get 'investigations/:investigation_id/crime_investigations/new', to: 'crime_investigations#new', as: 'new_crime_investigation'
    post 'crime_investigations', to: 'crime_investigations#create', as: 'crime_investigations'
    delete 'crime_investigations/:id', to: 'crime_investigations#destroy', as: 'remove_crimes'

    # Routes for investigation_notes
    get 'investigation_notes/new', to: 'investigation_notes#new', as: 'new_investigation_note'
    post 'investigation_notes', to: 'investigation_notes#create'
    

    # Other custom routes
    # home
    get 'home', to: 'home#index', as: :home
    get 'home/about', to: 'home#about', as: :about
    get 'home/contact', to: 'home#contact', as: :contact
    get 'home/privacy', to: 'home#privacy', as: :privacy
    # suspects
    get 'suspects/new', to: 'suspects#new', as: 'new_suspect'
    post 'suspects', to: 'suspects#create'
    patch 'suspects/:id/terminate', to: 'suspects#terminate', as: 'terminate_suspect'
    

    # You can have the root of your site routed with 'root'
    root 'home#index'
    
end
