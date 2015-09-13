class LoansController < ApplicationController
  before_action :set_loan, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:create]
  skip_before_action :authenticate_admin!, only: [:new, :create, :show, :destroy]

  # GET /loans
  # GET /loans.json
  def index
    @search = Loan.ransack(params[:q])
    @loans  = @search.result.paginate(:page => params[:page], :per_page => 10)
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
    item = Item.find_by_barcode(loan_params[:barcode])
    if item.total_available > 0
      @loan = Loan.new
      @loan.item = item
      @loan.user = @user
      @loan.due_date = (Time.now + 7.day).strftime('%Y-%m-%dT%T')
    end
    respond_to do |format|
      if @loan && @loan.save
        format.js
      else
        @loan = Loan.new
        format.json { render json: {error: "error"}}
        format.html { render :new }
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def loan_params
      params.require(:loan).permit(:user_id, :item_id,:barcode, :due_date)
    end
end
