Rails.application.routes.draw do
  root to: 'application#index'
  devise_for :admins
  devise_for :students
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
