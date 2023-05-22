Rails.application.routes.draw do
  get '/auth/google_oauth2/callback', to: 'sessions#create'
  get '/sites', to: 'sites#index'
end

