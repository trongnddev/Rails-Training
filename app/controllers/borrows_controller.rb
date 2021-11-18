class BorrowsController < ApplicationController
  before_action :set_borrow, only: %i[show edit update destroy]

  # GET /borrows or /borrows.json
  def index
    @borrows = Borrow.all
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
    @borrow.appointment_returned_date = 14
    respond_to do |format|
      if @borrow.save
        format.html { redirect_to books_path, notice: "Borrow was successfully borrowed." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /borrows/1 or /borrows/1.json
  def update
    respond_to do |format|
      if @borrow.update(borrow_params)
        format.html { redirect_to @borrow, notice: "Borrow was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /borrows/1 or /borrows/1.json
  def destroy
    @borrow.destroy
    respond_to do |format|
      format.html {redirect_to borrows_url, notice: "Borrow was successfully destroyed."}
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