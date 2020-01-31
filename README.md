# README
# Table of Contents  
1. [Introduction](#introduction)
2. [Features](#features)
3. [Endpoints](#endpoints)
2. [Installation](#installation-instructions)
5. [Things To Improve](#things-to-improve)  

# Introduction
Code Challenge written for Asana Rebel, it consist of an api only rails application with postgresql database.

## Features
* Authentication built with [`ruby-jwt`][4] library
* Geocoding perfomed with [`geocoder`][5] library
* `Rails` as api only with `potsgresql`

[4]: https://github.com/jwt/ruby-jwt
[5]: https://github.com/alexreisner/geocoder

## Endpoints
**Registrations** - User signs up with the `/api/v1/users/registrations`endpoint with email and password.  
The endpoint returns a `token`, valid for 12 hours.  
The request is available in [postman][1].

**Sessions** - User signs in with the `/api/v1/users/sessions` endpoint with email and password.  
The endpoint returns a `token`, valid for 12 hours.  
The request is available in [postman][2].

**Locations** - The `locations` endpoint `/api/v1/users/locations` is protected from authentication.  
The request `Authorization` header includes the `token`, takes an `address` query string and returns the `latitude` and `longitude`.  
The request is available in [postman][3].


[1]: https://documenter.getpostman.com/view/6379421/SWTD7bjv?version=latest#ffc7d96b-75f4-444c-a6a1-dbe0cef712d7 
[2]: https://documenter.getpostman.com/view/6379421/SWTD7bjv?version=latest#ab4fe4b4-d98b-4df3-85ef-855cb05fcb2djo
[3]: https://documenter.getpostman.com/view/6379421/SWTD7bjv?version=latest#4b2b980e-db6b-4120-9c59-734835b8c7c5

# Installation Instructions
ruby version `ruby 2.6.5`

rails `6.0.0`

Installation

```ruby
git clone git@github.com:fabriziobertoglio1987/asana.git
cd asana
bundle install
rails db:setup
```

run `rspec` for running test suite.
run `rails s` and test with [postman][6] request on your local environment.

[6]: https://documenter.getpostman.com/view/6379421/SWTD7bjv?version=latest#intro

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
