class Admin::CategoriesController < AdminController
  before_action :set_category, only: %i[show edit update destroy]
  before_action :authenticate_user!
  add_flash_types :success, :warning, :danger, :info

  def index
    @categories = Category.all.paginate(:page => params[:page], :per_page => 10).order('created_at desc')
  end


  def show; end

  def new
    @category = Category.new
  end


  def edit; end


  def create
    @category = Category.new(category_params)
      if @category.save
        redirect_to request.referrer 
        flash[:success] = "Category was successfully created!  #{view_context.link_to("Do you want check the #{@category.name}", "#{@category.id}")}"
      else
        respond_to do |format|
          format.html {render :new, status: :unprocessable_entity}
        end
      end
  end


  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html {redirect_to admin_categories_path, success:"Category was successfully updated!"}
      else
        format.html {render :edit, status: :unprocessable_entity}
      end
    end
  end


  def destroy
    @category.destroy
    redirect_to admin_categories_path
    flash[:info] = "Category was successfully destroyed!"
  end

  private


  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
