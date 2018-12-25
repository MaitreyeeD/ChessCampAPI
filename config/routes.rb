Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :curriculums
  resources :camps
  resources :instructors
  resources :locations
end
