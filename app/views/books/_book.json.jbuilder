json.extract! book, :id, :name, :description, :published_date, :publisher, :borrow_fee, :quantity, :quantity_in_stock, :created_at, :updated_at
json.url book_url(book, format: :json)
