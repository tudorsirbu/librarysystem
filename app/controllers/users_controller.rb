class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_admin!, only: [:new, :create, :show, :edit, :update]
  skip_before_action :session_active?, only: [:new, :create,:update,:edit]

  # GET /users
  # GET /users.json
  def index
    @search = User.ransack(params[:q])
    @users  = @search.result.paginate(:page => params[:page], :per_page => 10)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @loans = Loan.where(user_id: @user.id).order( 'returned_on DESC' )
  end

  # GET /users/new
  def new
    @user = User.new(ucard_no: params[:barcode])
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.find_by_email(user_params[:email])

    if @user
      @user.ucard_no = user_params[:ucard_no]
    else
      @user = User.new(user_params)
    end


    respond_to do |format|
      if @user.save
        login_user(@user.id)
        format.html { redirect_to menu_dashboard_index_path(user: {ucard_no: @user.ucard_no}), notice: 'Your account has been created successfully.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def find


    if user.nil?
      @user = User.new(ucard_no: user_params[:ucard_no])
      redirect_to new_user_path(@user)
    else
      redirect_to user_path(user)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:ucard_no, :surname,:email , :forename, :job_title)
    end
end
