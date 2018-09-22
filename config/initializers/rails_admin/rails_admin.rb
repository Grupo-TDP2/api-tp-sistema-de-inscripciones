RailsAdmin.config do |config|
  require 'i18n'
  I18n.default_locale = :es
  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  config.actions do
    dashboard
    index do
      except ['Admin', 'Building', 'Classroom', 'Correlativity', 'Course',
              'CourseOfStudy', 'Department', 'Subject', 'Student']
    end
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
