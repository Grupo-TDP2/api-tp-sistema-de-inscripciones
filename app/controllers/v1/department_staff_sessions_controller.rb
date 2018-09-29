module V1
  class DepartmentStaffSessionsController < SessionsController
    def user
      @user ||= DepartmentStaff.find_by(email: authenticate_params[:email])
    end
  end
end
