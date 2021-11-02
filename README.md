# README

* System dependencies
  - Ruby 3.0.1
  - Yarn 1.22
  - Rails 6.1.4

* Clone and Configuration
  - `git clone git@github.com:phamdat8/Rails-Training.git`
  
  - `cd Rails-Training`
  
  - ```ruby
  bundle
  ```
* Database creation

  - `cp config/database.example.yml config/database.yml`
  
  Setup your local postgres database 
  - `nano config/database.yml`

* Database initialization

  - `rails db:create`
  
  - `rails db:migrate`
* Run server

  - `rails s`

