class AuthorsController < ApplicationController
  before_action :set_author, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[show index]
  add_flash_types :success, :warning, :danger, :info

  # GET /authors or /authors.json
  def index
    @authors = Author.all.paginate(:page => params[:page], :per_page => 10)
  end

  # GET /authors/1 or /authors/1.json
  def show; end

  # GET /authors/new
  def new
    @author = Author.new
  
  end

  # GET /authors/1/edit
  def edit; end

  # POST /authors or /authors.json
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

  # PATCH/PUT /authors/1 or /authors/1.json
  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html {redirect_to authors_path, success: "Author was successfully updated!"}
      else
        format.html {redirect_to request.referrer, danger: "Something went wrong!"}
      end
    end
  end

  # DELETE /authors/1 or /authors/1.json
  def destroy
    @author.destroy
     redirect_to authors_url
     flash[:info] = "Author was successfully destroyed!"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_author
    @author = Author.find(params[:id])    
  end

  # Only allow a list of trusted parameters through.
  def author_params
    params.require(:author).permit(:author_name, :birthday, author_books_attributes: [:id, book_attributes: [:id, :name]])
  end
end
