class PublishersController < ApplicationController
  before_action :set_publisher, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[show index]

  # GET /publishers or /publishers.json
  def index
    @publishers = Publisher.all
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

    respond_to do |format|
      if @publisher.save
        format.html { redirect_to @publisher, notice: "Publisher was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publishers/1 or /publishers/1.json
  def update
    respond_to do |format|
      if @publisher.update(publisher_params)
        format.html { redirect_to @publisher, notice: "Publisher was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publishers/1 or /publishers/1.json
  def destroy
    @publisher.destroy
    respond_to do |format|
      format.html { redirect_to publishers_url, notice: "Publisher was successfully destroyed." }
    end
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
