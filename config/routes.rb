Rails.application.routes.draw do
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'application#index'
  devise_for :department_staffs
  devise_for :students
  devise_for :teachers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  api_version(module: 'v1', path: { value: 'api/v1' }, defaults: { format: :json }) do
    resources :school_terms
    resources :sessions, only: [:create]
    resources :classrooms, only: [:index]
    resources :final_exam_weeks, only: [:index]
    resources :import_files, only: %i[create index]
    resources :course_of_studies, only: [:index] do
      resources :subjects, only: [:index] do
        resources :courses, only: [:index] do
          get :exams
          resources :enrolments, only: [:create]
        end
      end
    end
    resources :students, only: [] do
      collection do
        scope :me do
          resources :student_exams, only: %i[index create destroy]
        end
      end
    end
    resources :teachers, only: [:index] do
      collection do
        scope :me do
          get :courses, to: 'teachers#my_courses'
          resources :courses, only: [:update] do
            get :enrolments
            resources :enrolments, only: [:update]
            get :exams
            resources :exams, only: [:destroy]
            post :exams, to: 'exams#create'
          end
        end
      end
    end
    resources :departments, only: [] do
      collection do
        scope :me do
          get :courses, to: 'departments#my_courses'
          resources :courses, only: %i[create show destroy] do
            get :exams
          end
          resources :subjects, only: [:index] do
            resources :courses, only: [] do
              post :teachers, to: 'courses#associate_teacher'
            end
          end
        end
      end
    end
  end
end
