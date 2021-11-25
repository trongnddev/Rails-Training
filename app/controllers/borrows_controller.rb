class BorrowsController < ApplicationController
  before_action :set_borrow, only: %i[show edit update destroy]
  before_action :authenticate_user!
  add_flash_types :success, :warning, :danger, :info

  # GET /borrows or /borrows.json
  def index
    if current_user.role == "user"
      @borrows = Borrow.where(user_id: current_user.id).order("id DESC")
    elsif current_user.role  == "staff"
      @borrows = Borrow.where(status: "waiting accept").order("id DESC")
    else 
      redirect_to root_path
    end
  end

  def showborrow
    if current_user.role == "staff"
      @borrows = Borrow.search("accept").order("id DESC")
    elsif current_user.role == "user"
      @borrows = Borrow.where(user_id: current_user.id).order("id DESC")
    else
      redirect_to root_path
    end
  end

  def showreturn
    if current_user.role == "staff"
      @borrows = Borrow.search("returned").order("id DESC")
    elsif current_user.role == "user"
      @borrows = Borrow.where({user_id: current_user.id, status:  "returned"}).order("id DESC")
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
        if @borrow.status.include? "accept"
          current_book.update_attribute :quantity_in_stock, update_stock - 1
          @borrow.update_attribute :borrowed_date, Time.now
          format.html { redirect_to borrows_path}

        elsif @borrow.status.include? "returned"
          @borrow.update_attribute :returned_date, Time.now
          days_penalty = (@borrow.returned_date.day- @borrow.borrowed_date.day).to_i - @borrow.appointment_returned_date
          
          if days_penalty > 0
            penalty_fee = days_penalty * @borrow.book.borrow_fee * 0.5
          else
            penalty_fee = 0
          end

          
          @borrow.update_attribute :penalty_fee, penalty_fee
          current_book.update_attribute :quantity_in_stock, update_stock + 1 
          format.html { redirect_to request.referrer, success: "You had update status successfully" }
        end

      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /borrows/1 or /borrows/1.json
  def destroy
    if @borrow.status =="accept"
   
      current_quantity = @borrow.book.quantity_in_stock
      current_book = Book.find(@borrow.book.id)
      current_book.update_attribute :quantity_in_stock, current_quantity + 1
    end

    @borrow.destroy
    respond_to do |format|
      format.html { redirect_to borrows_url, notice: "Book was successfully destroyed." }
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
