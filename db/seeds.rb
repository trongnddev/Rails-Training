require "csv"

puts 'Deleting data...'
Book.destroy_all
Category.destroy_all
Publisher.destroy_all
Author.destroy_all
AuthorBook.destroy_all
User.destroy_all
Review.destroy_all

puts 'Scanning data...'
User.create(email: "admin@email.com", password: "111111", password_confirmation: "111111", role: 'admin')
User.create(email: "staff@email.com", password: "111111", password_confirmation: "111111", role: 'staff')

for i in 1..50
    User.create(email: "user_#{i}@email.com", password: "111111", password_confirmation: "111111")
    puts "User #{i} created"
end

csv_text = File.read(Rails.root.join("public", "book.csv"))
csv = CSV.parse(csv_text, :headers => false)
csv.each do |row|
    begin
        category = Category.find_or_create_by(name: row[4])
        publisher = Publisher.find_or_create_by(publisher_name: row[2])
        book = Book.new(name: row[0], published_date: row[1], borrow_fee: rand(1..20)*1000, quantity: 10, quantity_in_stock: 10, publisher_id: publisher.id, category_id: category.id)
        downloaded_image =  URI.parse(row[3]).open
        book.image.attach(io: downloaded_image, filename: row[3])
        book.save(validate: false)
        authors = row[5].split(", ")
        authors.each do |name|
            author = Author.find_or_create_by(author_name: name)
            author.save(validate: false)
            AuthorBook.create(author_id: author.id, book_id: book.id)
        end
        puts "Created book #{row[0]}"  
    rescue => exception
    end
    
end
