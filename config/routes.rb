Rails.application.routes.draw do
  devise_for :department_staffs
  root to: 'application#index'
  devise_for :admins
  devise_for :students
  devise_for :teachers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  api_version(module: 'v1', path: { value: 'api/v1' }, defaults: { format: :json }) do
    resources :department_staff_sessions, only: [:create]
    resources :student_sessions, only: [:create]
    resources :teacher_sessions, only: [:create]
    resources :course_of_studies, only: [:index] do
      resources :subjects, only: [:index] do
        resources :courses, only: [:index] do
          resources :enrolments, only: [:create]
        end
      end
    end
    resources :teachers, only: [:index] do
      collection do
        scope :me do
          get :courses, to: 'teachers#my_courses'
          resources :courses, only: [] do
            get :enrolments
          end
        end
      end
    end
    resources :departments, only: [] do
      collection do
        scope :me do
          resources :subjects, only: [] do
            resources :courses, only: [] do
              post :teachers, to: 'courses#associate_teacher'
            end
          end
        end
      end
    end
  end
end
