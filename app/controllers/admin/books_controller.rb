class Admin::BooksController < AdminController
  before_action :set_book, only: %i[show edit update destroy]
  add_flash_types :success, :warning, :danger, :info

  def index 
    @book = Book.search(params[:search]).paginate(:page => params[:page], :per_page => 10).order('created_at desc')
  end

  def show
  end

  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @book = Book.new(book_params)
    @book.created_at = Time.now
    if @book.save
      redirect_to request.referrer
      flash[:success] = "Book was successfully created! #{view_context.link_to("Do you want check the #{@book.name} book", "#{@book.id}")}"
    else
      respond_to do |format|
        format.html{ redirect_to new_admin_book_path, danger: "Something went wrong!"}
      end
    end
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html {redirect_to admin_books_path, success:"Book was successfully updated!"}
      else
        format.html { redirect_to request.referrer, danger:"Something went wrong!"}
      end
    end
  end

  def destroy
    @book.destroy
    redirect_to admin_books_path
    flash[:info] = "Book was successfully destroyed!"
  end

  private

  def set_book 
    @book = Book.find(params[:id]) 
  end

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
