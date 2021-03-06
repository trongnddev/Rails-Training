class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[show index]
  add_flash_types :success, :warning, :danger, :info

  #authorization with cancancan
  load_and_authorize_resource

  # GET /categories or /categories.json
  def index
    @categories = Category.all.paginate(:page => params[:page], :per_page => 12).order("name ASC")
  end

  # GET /categories/1 or /categories/1.json
  def show; end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit; end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)
      if @category.save
        redirect_to request.referrer 
        flash[:success] = "Category was successfully created!  #{view_context.link_to("Do you want check the #{@category.name}", "#{@category.id}")}"
      else
        respond_to do |format|
          format.html {redirect_to request.referrer, danger: "Something went wrong!"}
        end
      end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html {redirect_to categories_url, success:"Category was successfully updated!"}
      else
        format.html {redirect_to request.referrer, danger: "Something went wrong!"}
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category.destroy
    redirect_to categories_url
    flash[:info] = "Category was successfully destroyed!"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def category_params
    params.require(:category).permit(:name, :description)
  end
end
