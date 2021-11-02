# README

* System dependencies
  - Ruby 3.0.1
  - Yarn 1.22
  - Rails 6.1.4

* Clone and Configuration
```console
git clone git@github.com:phamdat8/Rails-Training.git
```

```console
cd Rails-Training
```
  
```console
bundle install
```
* Database creation
```console
cp config/database.example.yml config/database.yml
```
  
  Setup your local postgres database 
```console
nano config/database.yml
```

* Database initialization

```console
rails db:create
```
  
```console
rails db:migrate
```
* Run server

```console
rails s
```

