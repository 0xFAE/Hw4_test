Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  
  
  get '/movies/:id/find_same_director', to: 'movies#find_same_director', as: 'find_same_director' 
end