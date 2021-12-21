class Admin::PublishersController < AdminController
    before_action :set_publisher, only: %i[show edit update destroy]
    before_action :authenticate_user!
    add_flash_types :success, :warning, :danger, :info

    #authorization with cancancan
    load_and_authorize_resource

    def index
      @publishers = Publisher.all
    end
  
    def show; end
  
    def new
      @publisher = Publisher.new
    end
  
    def edit; end
  

    def create
      @publisher = Publisher.new(publisher_params)
        if @publisher.save
          redirect_to request.referrer 
          flash[:success] = "Publisher was successfully created!#{view_context.link_to("Do you want to check the #{@publisher.publisher_name}","#{@publisher.id}")}" 
        else
          respond_to do |format|
            format.html {render :new, status: :unprocessable_entity}
          end
        end
    end

    def update
      respond_to do |format|
        if @publisher.update(publisher_params)
          format.html { redirect_to admin_publishers_path, success: "Publisher was successfully updated!"}
        else
            format.html {render :edit, status: :unprocessable_entity}
        end
      end
    end

    def destroy
      @publisher.destroy
       redirect_to admin_publishers_path
       flash[:info] = "Publisher was successfully destroyed!"
    end
  
    private

    def set_publisher
      @publisher = Publisher.find(params[:id])
    end
  
    def publisher_params
      params.require(:publisher).permit(:publisher_name)
    end
end
  
