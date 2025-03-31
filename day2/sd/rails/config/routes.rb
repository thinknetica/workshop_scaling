Rails.application.routes.draw do

  #get "/:any", controller: "application", action: :any
  match "/:action", controller: "application", via: :all, defaults: { format: :txt }

end
