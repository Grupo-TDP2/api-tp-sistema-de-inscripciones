Rails.application.routes.draw do
  root to: 'application#index'
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web, at: 'sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  api_version(module: 'v1', path: { value: 'api/v1' }, defaults: { format: :json }) do
    resources :school_terms, only: %i[create index destroy show]
    resources :sessions, only: [:create]
    resources :classrooms, only: [:index]
    resources :final_exam_weeks, only: [:index]
    resources :import_files, only: %i[create index]

    resources :course_of_studies, only: [:index] do
      resources :subjects, only: [:index] do
        resources :courses, only: [:index] do
          resources :exams, only: %i[index]
          resources :enrolments, only: %i[create destroy]
        end
      end
    end

    resources :students, only: [:index] do
      collection do
        scope :me do
          get :show
          patch :update
          resources :student_exams, only: %i[index create destroy show]
          get :approved_subjects, to: 'students#approved_subjects'
          get :pending_exam_courses, to: 'students#pending_exam_courses'
          resources :polls, only: %i[index create]
        end
      end
    end

    resources :teachers, only: [:index] do
      get :courses, to: 'teachers#courses'
      resources :courses, only: [:update] do
        resources :enrolments, only: %i[index update create]
        resources :exams, only: %i[create destroy index] do
          resources :student_exams, only: %i[index update] do
            collection do
              get :csv_format
            end
          end
        end
      end
    end

    resources :reports, only: [] do
      collection do
        get :polls
        get :subject_enrolments
      end
    end

    resources :departments, only: [:index] do
      resources :subjects, only: [:index]
      get :courses, to: 'departments#my_courses'
      resources :courses, only: %i[create show destroy update] do
        post :teachers, to: 'courses#associate_teacher'
        resources :enrolments, only: %i[index update]
        resources :exams, only: %i[create destroy index] do
          resources :student_exams, only: %i[index update] do
            collection do
              get :csv_format
            end
          end
        end
      end
    end
  end
end
