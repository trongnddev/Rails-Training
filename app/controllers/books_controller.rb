class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[show index]

  # GET /books or /books.json
  def index
    if user_signed_in?
      if current_user.role == "user" 
        @books = Book.search(params[:search]).paginate(page: params[:page], per_page: 10).order("books.created_at DESC")
        render :index
      elsif current_user.role == "staff"
        @books = Book.search(params[:search]).paginate(page: params[:page], per_page: 10).order("books.created_at DESC")
        render :indexstaff
      else
        redirect_to root_path
      end
    else
      @books = Book.search(params[:search]).paginate(page: params[:page], per_page: 10).order("books.created_at DESC")
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
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
    end
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
