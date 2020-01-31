# README
#### Table of Contents  
1. [Introduction](#introduction)
2. [Project Design](#project-design)
3. [Features](#features)
4. [Endpoints](#endpoints)
5. [Error Handling](#error-handling)
6. [Installation](#installation-instructions)
7. [Things To Improve](#things-to-improve)  

## Introduction
Code Challenge written for Asana Rebel, it consist of an api only rails application with postgresql database.  
The application was built with [`alexreise/geocoder` gem][5] as by email instructions received from the company.

## Project Design

**Authentication**: The authentication is based on [`ruby-jwt`][4], instead of using [`nsarno/knock`][5].  
My decision was to build a custom solution with `ruby-jwt` and to showcase my passion and programming skills.  
**Geocoder**: The geocoding functionalities are built with [`geocoder`][5] gem, as agreed by email with Asana.

[5]: https://github.com/nsarno/knock
[6]: https://github.com/nsarno/knock#is-this-being-maintained

## Features
* Authentication built with [`ruby-jwt`][4] library
* Geocoding perfomed with [`geocoder`][5] library
* `Rails` as api only with `potsgresql`
* Complete test suite written with `rspec`, `rspec-mocks` and `factory-bot`.

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

The application handles the following errors:  
1) The token is invalid or expired
2) Geocoder Api limit is reached
3) Geocoder Api - Location not found 
4) Other errors will return status 500 - Internal Server Error

[1]: https://documenter.getpostman.com/view/6379421/SWTD7bjv?version=latest#ffc7d96b-75f4-444c-a6a1-dbe0cef712d7 
[2]: https://documenter.getpostman.com/view/6379421/SWTD7bjv?version=latest#ab4fe4b4-d98b-4df3-85ef-855cb05fcb2djo
[3]: https://documenter.getpostman.com/view/6379421/SWTD7bjv?version=latest#4b2b980e-db6b-4120-9c59-734835b8c7c5

## Error Handling

#### Geocoder
I quote the [Geocoder][7] documentation:
>By default Geocoder will rescue any exceptions raised by calls to a geocoding service and return an empty array.   

1) Exception `Geocoder::OverQueryLimitError`   
The http request has response body `{"errors": ["Geocoder API daily limit reached"]}` with status `403`.   
2) The other exceptions follow the standard `Geocoder` behaviour, the response has status `404` and body `{ errors: ['Location not found']}`. 

```
SocketError
Timeout::Error
Geocoder::RequestDenied
Geocoder::InvalidRequest
Geocoder::InvalidApiKey
Geocoder::ServiceUnavailable
```
I quote the question from the Asana Challenge:
>What happens if we encounter an error with the third-party API integration? Will it also break our application, or are they handled accordingly?

1) `Geocoder::OverQueryLimitError` is given a special behaviour. The client must know the root cause of the error as he may be the one performing too many requests, for example the mobile app is performing 1000 requests each time the user presses a specific bottom, while the client requirements are to perform only 1 request.
2) `InvalidApiKey`, `ServiceUnavailable` and the other errors are not relevant for the client, which does not need the information and can not fix the disfunctionality. I consider status `500` and `internal server error` an appropriate response. The error will not break the client functionality, as long as the client handles this scenarios.


[7]: https://github.com/alexreisner/geocoder#error-handling

#### Json Web Token
The Json Web Token expires every 12 hours. The client needs to re-authenticate at the `/sessions` endpoint.
Malformed or Expired tokens are rescued with `JWT::DecodeError` which returns http response status `401` Unauthorized with body `{errors: ["Unauthorized, Token invalid or expired"]}`.

## Installation Instructions
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
