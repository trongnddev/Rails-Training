class Admin::BorrowsController < AdminController
    before_action :set_borrow, only: %i[show edit update destroy]
    before_action :authenticate_user! 
    before_action :check_staff
    add_flash_types :success, :warning, :danger, :info

    
    
    def check_staff
      user ||= current_user
      
        if user.role in ["admin", "staff"]
          redirect_to root_path
        end
      
    end


    def index
        @borrows = Borrow.where(status: "waiting accept").paginate(:page=> params[:page], :per_page => 10).order("id DESC")
    end
  
    def showborrow
        @borrows = Borrow.search("accept").paginate(:page => params[:page], :per_page => 10).order("id DESC")
    end
  
    def showreturn
        @borrows = Borrow.search("returned").paginate(:page => params[:page], :per_page => 10).order("id DESC")
    end
  
    def show
    end

    def new
      @borrow = Borrow.new
    end

    def edit
    end
  

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
  
    def update
      respond_to do |format|
        if @borrow.update(borrow_params)
          format.html { redirect_to request.referrer, success:"Borrow was updated!"}
        else
          format.html { redirect_to request.referrer, danger: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @borrow.destroy
      respond_to do |format|
        format.html { redirect_to admin_borrows_path, notice: "Book was successfully destroyed." }
      end
        
    end
  
    
    private
 
      def set_borrow
        @borrow = Borrow.find(params[:id])
      end

      def borrow_params
        params.require(:borrow).permit(:status)
      end
  end
  