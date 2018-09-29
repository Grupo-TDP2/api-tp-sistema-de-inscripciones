module V1
  class TeacherSessionsController < SessionsController
    def user
      @user ||= Teacher.find_by(email: authenticate_params[:email])
    end
  end
end
