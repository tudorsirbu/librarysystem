class DashboardController < ApplicationController
  skip_before_action :authenticate_admin!
  skip_before_action :session_active?

  def index
  end

  def menu
    # find the user with the given barcode
    @user = User.find_by_ucard_no(params[:user][:ucard_no])

    if @user.nil?
      redirect_to new_user_path(barcode: params[:user][:ucard_no])
    else
      login_user(@user.id)
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:ucard_no)
    end
end
