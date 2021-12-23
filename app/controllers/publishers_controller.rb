class PublishersController < ApplicationController
  before_action :set_publisher, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[show index]
  add_flash_types :success, :warning, :danger, :info


  #authorization with cancancan
  load_and_authorize_resource

  # GET /publishers or /publishers.json
  def index
    @publishers = Publisher.all.paginate(:page => params[:page], :per_page => 12).order("publisher_name ASC")
  end

  # GET /publishers/1 or /publishers/1.json
  def show; end

  # GET /publishers/new
  def new
    @publisher = Publisher.new
  end

  # GET /publishers/1/edit
  def edit; end

  # POST /publishers or /publishers.json
  def create
    @publisher = Publisher.new(publisher_params)
      if @publisher.save
        redirect_to request.referrer 
        flash[:success] = "Publisher was successfully created!#{view_context.link_to("Do you want to check the #{@publisher.publisher_name}","#{@publisher.id}")}" 
      else
        respond_to do |format|
          format.html {redirect_to request.referrer, danger: "Something went wrong!"}
        end
      end
  end

  # PATCH/PUT /publishers/1 or /publishers/1.json
  def update
    respond_to do |format|
      if @publisher.update(publisher_params)
        format.html { redirect_to publishers_url, success: "Publisher was successfully updated!"}
      else
        format.html {redirect_to request.referrer, danger: "Something went wrong!"}
      end
    end
  end

  # DELETE /publishers/1 or /publishers/1.json
  def destroy
    @publisher.destroy
     redirect_to publishers_url
     flash[:info] = "Publisher was successfully destroyed!"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_publisher
    @publisher = Publisher.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def publisher_params
    params.require(:publisher).permit(:publisher_name)
  end
end
