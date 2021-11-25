class ReviewsController < ApplicationController
    before_action :authenticate_user!
    add_flash_types :success, :warning, :danger, :info
    def create
      @review = Review.new(review_params)
      @review.user_id = current_user.id
      @review.book_id = params[:book_id]
      if @review.save
        @book = Book.find(params[:book_id])
        current_rating = @book.rating
        @book.rating = (current_rating.to_i + @review.star.to_i)/ Review.where(book_id: params[:book_id]).count.to_i
        @book.save  
        redirect_to request.referrer
        flash[:success] = "Thank you for review!"
      else
        respond_to do |format|
          format.html { redirect_to request.referrer, danger:"Something went wrong!"}
        end
      end
    end



    private
    def review_params
      params.require(:review).permit(:comment, :star)
    end
end
