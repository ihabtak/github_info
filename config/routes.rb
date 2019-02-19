Rails.application.routes.draw do
  get  '/', to: 'app#index'
  get  '/show', to: 'app#show'
  get  '/list_history', to: 'app#list_history'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
