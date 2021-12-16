class ReviewsController < ApplicationController
    before_action :authenticate_user!
    add_flash_types :success, :warning, :danger, :info
    
    
    #authorization with cancancan
    load_and_authorize_resource 

   def show
    
    @book = Book.find(params[:book_id])
    @review = @book.reviews.find(params[:id])
    @review.destroy
    flash[:info] = "Delete review successfully" 
    redirect_to book_path(@book)
   end
     
   

    def create
      @review = Review.new(review_params)
      @review.user_id = current_user.id
      @review.book_id = params[:book_id]
      if @review.save
        redirect_to request.referrer
        flash[:success] = "Thank you for review!"
      else
        respond_to do |format|
          format.html { redirect_to request.referrer, danger:"Something went wrong!"}
        end
      end
    end

    # def destroy
    #   @review = Review.find(params[:id])
    #   @review.destroy
    #   redirect_to books_path(params[:book_id])
    #   flash[:info] = "Deleted!"
    # end



    private

   

    def review_params
      params.require(:review).permit(:comment, :star)
    end
end
