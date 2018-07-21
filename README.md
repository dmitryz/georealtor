# Georealtor API

## Getting started

1. Clone the repo
  ```
  $ git clone git@github.com:dmitryz/georealtor.git
  $ cd georealtor
  ```
1. Install dependencies
  ```
  $ bundle install
  ```
1. Whatch the scpecs pass
  ```
  $ ./bin/rspec
  ```
1. Define environment variables:
  ```
  GEOCLIENT_URL = 'https://hhq917q0a4.execute-api.eu-central-1.amazonaws.com/dev/task/geo_service'
  PRICES_SERVICE_URL = 'https://hhq917q0a4.execute-api.eu-central-1.amazonaws.com/dev/task/price_service'
  ```

## API

1. Estimate address prices:
  ```
  REQUEST: GET /estimate/addresses/search?query=address
  SUCCESSFULL RESPONSE CODE: 200
  UNPROCESSIBLE RESPONSE CODE: 422
  RESPONSE BODY (json):

  {"address":"Checkpoint Charly, 8, Wasserturmstraße, Burgberg, Erlangen, Mittelfranken, Bayern, 91054, Deutschland","city":{"name":"Erlangen","prices":{"sales":{"house":2027.0,"apartment":80.0},"rent":{"house":12027.0,"apartment":47.11}}},"zip_code":{"name":"91054","prices":{"sales":{"house":3463.0,"apartment":180.0},"rent":{"house":5463.0,"apartment":80.0}}}}
  ```

## Description

1. Implemented Ruby philosophy of duck typing, on Geocoder library.
As such we can quickly add any new external geocode adapter.
1. Dependency injection of adapters in geocode resolver, as result low coupled and testable classes.
1. DeviseTokenAuth gem, Simple, multi-client and secure token-based authentication for Rails. Very useful for single page application.
1. Representers decorator for json output a rich set of options and semantics for parsing and rendering documents.

## Guideline answers
1. By default configurations values represented in environment and if values will be changed it will require redeployment.
But all configurations wrapped to GeocoderConfig service which could be easilly changed to load configurations from database and cache them in key/value storage.
1. All possible errors from third party API will not break application, all those errors will be represented in endpoint answers with according code errors

