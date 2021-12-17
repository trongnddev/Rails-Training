class HomeController < ApplicationController

  

  def index
    @hot_book = Book.hotbooks
    @newest_books = Book.newest
  end
  
  def about; end
end
