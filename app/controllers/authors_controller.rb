class AuthorsController < ApplicationController
  before_action :set_author, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[show index]

  # GET /authors or /authors.json
  def index
    @authors = Author.all
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

    respond_to do |format|
      if @author.save
        format.html { redirect_to @author, notice: "Author was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authors/1 or /authors/1.json
  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to @author, notice: "Author was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authors/1 or /authors/1.json
  def destroy
    @author.destroy
    respond_to do |format|
      format.html { redirect_to authors_url, notice: "Author was successfully destroyed." }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
  def set_author
    @author = Author.find(params[:id])    
  end

    # Only allow a list of trusted parameters through.
  def author_params
    params.require(:author).permit(:author_name, :birthday, author_books_attributes: [:id, book_attributes: [:name]])
  end
end
