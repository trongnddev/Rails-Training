User.create(email: "admin@email.com", password: "111111", password_confirmation: "111111")

for i in 1..50
    User.create(email: "user_#{i}@email.com", password: "111111", password_confirmation: "111111")
    puts "User #{i} created"
end