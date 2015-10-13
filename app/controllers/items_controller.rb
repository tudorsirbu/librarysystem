class ItemsController < ApplicationController
  include ItemsHelper
  skip_before_action :authenticate_admin!, only: [:index, :return, :return_scan, :request_item]
  before_action :set_item, only: [:show, :edit, :update, :destroy, :request_item, ]
  before_action :session_active?, only: [:return_scan]

  # GET /items
  # GET /items.json
  def index
    @search = Item.ransack(params[:q])
    @items  = @search.result.paginate(:page => params[:page], :per_page => 10)
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.find_by_barcode(item_params[:barcode])

    if @item.nil?
      @item = Item.new(item_params)
      @item.copies = 1
      # get additional information about the item on external APIs
      lookup_by_isbn(@item)
    else
      @item.copies += 1
    end

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    if @item.copies == 1
      @item.destroy
    else
      @item.copies -= 1
      @item.save
    end

    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def return
    item = Item.find_by_barcode(params[:loan][:barcode])

    respond_to do |format|
      # mark the loan oldest loan for this user and item as returned
      if user_active? && item.return(current_user)
        format.json { render json: {success: true, error:nil} }
      else
        format.json { render json: {error: "error"}}
      end
    end
  end

  def return_scan
  end

  def request_item
    request = ItemRequest.new
    request.user = current_user
    request.item_id = @item.id

    @item.loans.where(user_id: current_user.id).each do |loan|
      UserMailer.item_requested(loan).deliver_now
    end

    respond_to do |format|
      if user_active? && request.save
        format.json { render json: {success: true} }
      else
        format.json { render json: {error: "error"}}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:title, :barcode, :category_id, :location_id, :publisher, :year)
    end
end
