module V1
  class StudentSessionsController < SessionsController
    def user
      @user ||= Student.find_by(email: authenticate_params[:email])
    end
  end
end
