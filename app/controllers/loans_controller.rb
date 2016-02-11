class LoansController < ApplicationController
  before_action :set_loan, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:create]
  skip_before_action :authenticate_admin!, only: [:new, :create, :show, :destroy,:index,:change_loan_period]
  before_action :session_active?, only: [:new, :create, :show, :destroy]
  before_action :load_location, only: :create

  # GET /loans
  # GET /loans.json
  def index
    if user_active?
      @search = Loan.ransack({"loan_user_search"=> current_user.id})
      @loans  = @search.result.order(:due_date).paginate(:page => params[:page], :per_page => 25)
    elsif admin_signed_in?
      @search = Loan.ransack(params[:q])
      @loans  = @search.result.order(:user_id,:due_date).paginate(:page => params[:page], :per_page => 25)
    else
      session_active?
    end
  end

  # GET /loans/1
  # GET /loans/1.json
  def show
  end

  # GET /loans/new
  def new
    if user_active?
      @loan = Loan.new
    else
      redirect_to dashboard_index_path
    end
  end

  # GET /loans/1/edit
  def edit
  end

  # POST /loans
  # POST /loans.json
  def create
    if @location
      item = Item.find_by_barcode_and_location_id(loan_params[:barcode],@location.id)
    else
      message = "location not set"
    end

    if item && item.total_available > 0
      @loan = Loan.new
      @loan.item = item
      @loan.user = @user
      @loan.due_date = (Time.now + 14.day).strftime('%Y-%m-%dT%T')
    elsif item.nil?
      message = "item not found at this location"
    elsif item.total_available == 0
      message = "this item was not returned properly"

    end
    respond_to do |format|
      if @loan && @loan.save
        format.js
      else
        @loan = Loan.new
        format.json { render json: {error: "Loan not created because " + message}}
        format.html { render :new }
      end
    end
  end

  def change_loan_period
    loan = Loan.find(params[:id])
    respond_to do |format|
      if loan
        loan.update_attribute(:due_date, params[:due_date])
        format.js {  render action: 'changed_loan_end_date'}
      else
        format.js {  render action: 'not_changed_loan_end_date'}
      end
    end
  end

  def send_loan_reminders_due_today
    loans = Loan.where(returned_on:nil)
    loans.each do |loan|
      sleep(30)
      time = (loan.due_date - Time.zone.now)/3600
      if time <= 24 && time >= 0
        UserMailer.loan_expires_soon(loan).deliver_now
      elsif time < 0
        UserMailer.overdue_item_reminder(loan).deliver_now
      end
    end
  end

  # PATCH/PUT /loans/1
  # PATCH/PUT /loans/1.json
  def update
    respond_to do |format|
      if @loan.update(loan_params)
        format.html { redirect_to @loan, notice: 'Loan was successfully updated.' }
        format.json { render :show, status: :ok, location: @loan }
      else
        format.html { render :edit }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loans/1
  # DELETE /loans/1.json
  def destroy
    @id = @loan.id
    @loan.destroy
    respond_to do |format|
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan
      @loan = Loan.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end
    def load_location
      if cookies.has_key?(:location) && !cookies[:location].empty?
        @location = Location.find(cookies[:location])
      else
        @location = nil
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def loan_params
      params.require(:loan).permit(:user_id, :item_id,:barcode, :due_date)
    end
end
