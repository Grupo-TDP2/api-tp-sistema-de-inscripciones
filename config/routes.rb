Rails.application.routes.draw do
  root to: 'application#index'
  devise_for :admins
  devise_for :students
  devise_for :teachers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  api_version(module: 'v1', path: { value: 'api/v1' }, defaults: { format: :json }) do
    resources :sessions, only: [:create]
    resources :course_of_studies, only: [:index] do
      resources :subjects, only: [:index] do
        resources :courses, only: [:index] do
          resources :enrolments, only: [:create]
        end
      end
    end
  end
end
