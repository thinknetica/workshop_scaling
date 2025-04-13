Rails.application.routes.draw do

  #get "/:any", controller: "application", action: :any
  get '/sync_sleep/:seconds', to: 'metrics#sync_sleep'
  get '/cached_heavy_query', to: "metrics#cached_heavy_query"

  match "/:action", controller: "application", via: :all, defaults: { format: :txt }
end
