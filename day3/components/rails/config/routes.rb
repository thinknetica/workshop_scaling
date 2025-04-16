Rails.application.routes.draw do

  #get "/:any", controller: "application", action: :any
  post '/data/input', to: 'data#input'
  match "/:action", controller: "application", via: :all, defaults: { format: :txt }

end
