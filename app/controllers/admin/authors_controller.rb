class Admin::AuthorsController < AdminController
    before_action :set_author, only: %i[show edit update destroy]
    before_action :authenticate_user!
    add_flash_types :success, :warning, :danger, :info
  

    #authorization with cancancan
    load_and_authorize_resource

    def index
      @authors = Author.all
    end
  
    def show; end
  
    def new
      @author = Author.new
    
    end

    def edit; end
  
    def create
      @author = Author.new(author_params)
        if @author.save
          redirect_to request.referrer 
          flash[:success]= "Author was successfully created!  #{view_context.link_to("Do you want check the #{@author.author_name}", "#{@author.id}")}"
        else
          respond_to do |format|
            format.html {redirect_to request.referrer, danger: "Something went wrong!"}
          end
        end
    end
  
    def update
      respond_to do |format|
        if @author.update(author_params)
          format.html {redirect_to admin_authors_path, success: "Author was successfully updated!"}
        else
          format.html {redirect_to request.referrer, danger: "Something went wrong!"}
        end
      end
    end
  
    def destroy
      @author.destroy
       redirect_to request.referrer
       flash[:info] = "Author was successfully destroyed!"
    end
  
    private
  
    def set_author
      @author = Author.find(params[:id])    
    end
  
    def author_params
      params.require(:author).permit(
        :author_name,
        :birthday,
        :image,         
        author_books_attributes: [:id, book_attributes: [:id, :name]]
        )
    end
end
