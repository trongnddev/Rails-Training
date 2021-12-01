class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[show index]
  add_flash_types :success, :warning, :danger, :info

  # GET /books or /books.json
  def index
    if user_signed_in?
      if current_user.role == "user" 
        @books = Book.all
        render :index
      elsif current_user.role == "staff"
        @books = Book.all.paginate(:page => params[:page], :per_page => 10)
        render :indexstaff
      else
        redirect_to root_path
      end
    else
      @books = Book.all
      render :index
    end
  end

  # GET /books/1 or /books/1.json
  def show; end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit; end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)
    @book.created_at = Time.now
      if @book.save
        redirect_to request.referrer
        flash[:success] = "Book was successfully created! #{view_context.link_to("Do you want check the #{@book.name} book", "#{@book.id}")}"
      else
        respond_to do |format|
          format.html{ redirect_to request.referrer, danger: "Something went wrong!"}
        end
      end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html {redirect_to books_path, success:"Book was successfully updated!"}
      else
        format.html { redirect_to request.referrer, danger:"Something went wrong!"}
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy
    redirect_to books_path
    flash[:info] = "Book was successfully destroyed!"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book 
    @book = Book.find(params[:id]) 
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:name,
       :description,
       :published_date,
       :publisher_id,
       :borrow_fee,
       :quantity,
       :quantity_in_stock,
       :image,
       :category_id,
       author_books_attributes: [:id, author_attributes: [:id, :author_name]])
  end
end
