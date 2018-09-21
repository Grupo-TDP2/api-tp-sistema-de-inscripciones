Rails.application.routes.draw do
  root to: 'application#index'
  devise_for :admins
  devise_for :students
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  api_version(module: 'v1', path: { value: 'api/v1' }, defaults: { format: :json }) do
    resources :course_of_studies, only: [] do
      resources :subjects, only: [:index]
    end
  end
end
