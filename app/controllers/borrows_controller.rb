class BorrowsController < ApplicationController
  before_action :set_borrow, only: %i[show edit update destroy]
  before_action :authenticate_user!

  # GET /borrows or /borrows.json
  def index
    if current_user.role == "user"
      @borrows = Borrow.where(user_id: current_user.id).order("id DESC")
    elsif current_user.role  == "staff"
      @borrows = Borrow.where(status: "waiting accept").order("id DESC")
    end
  end

  def showborrow
    if current_user.role == "staff"
      @borrows = Borrow.search("accept").order("id DESC")
    else
      redirect_to root_path
    end
  end

  def showreturn
    if current_user.role == "staff"
      @borrows = Borrow.search("returning").order("id DESC")
    else
      redirect_to root_path
    end
  end

  # GET /borrows/1 or /borrows/1.json
  def show
  end

  # GET /borrows/new
  def new
    @borrow = Borrow.new
  end

  # GET /borrows/1/edit
  def edit
  end

  # POST /borrows or /borrows.json
  def create
    @borrow = Borrow.new(borrow_params)
    @borrow.user_id = current_user.id
    @borrow.book_id = params[:book_id]
    @borrow.borrowed_date = Time.now
    @borrow.appointment_returned_date = 14
    respond_to do |format|
      if @borrow.save
        format.html { redirect_to request.referrer, notice: "Book was successfully borrowed." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /borrows/1 or /borrows/1.json
  def update
    update_stock = @borrow.book.quantity_in_stock
    current_book = Book.find(@borrow.book.id)
    respond_to do |format|
      if @borrow.update(borrow_params)
        current_book.update_attribute :quantity_in_stock, update_stock  - 1 if @borrow.status.include? "accept"
        format.html { redirect_to borrows_path}
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /borrows/1 or /borrows/1.json
  def destroy
    if @borrow.status =="waiting accept" or "cancel"
      @borrow.destroy
      respond_to do |format|
        format.html { redirect_to borrows_url, notice: "Book was successfully destroyed." }
      end
    elsif  @borrow.status == "accept"
      update_stock = @borrow.book.quantity_in_stock
      current_book = Book.find(@borrow.book.id)
      current_book.update_attribute :quantity_in_stock, (update_stock  + 1)
      @borrow.destroy
    end
      
  end

  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_borrow
      @borrow = Borrow.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def borrow_params
      params.require(:borrow).permit(:status)
    end
end
