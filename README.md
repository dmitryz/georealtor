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
1. Watch the specs pass
  ```
  $ ./bin/rspec
  ```
1. `cp .env.example .env`
   `cp .env.example .env.test.local`
1. Or just run (rspec/rubocop, bundle install):
  `make`
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

  SUCCESS RESPONSE:
  {"address":"Checkpoint Charly, 8, Wasserturmstraße, Burgberg, Erlangen, Mittelfranken, Bayern, 91054, Deutschland","city":{"name":"Erlangen","prices":{"sales":{"house":2027.0,"apartment":80.0},"rent":{"house":12027.0,"apartment":47.11}}},"zip_code":{"name":"91054","prices":{"sales":{"house":3463.0,"apartment":180.0},"rent":{"house":5463.0,"apartment":80.0}}}}
  ```

## Description

1. Implemented Gateway service as the main aggregator of different price and geolocation services.
1. Dependency injection of adapters in GeoClient, PricesClient, as a result low coupled and testable classes.
1. Dependency injection of adapters configuration.
1. Error handling in GatewayEstimateService class.
1. Caching
1. Docker
  ```
  docker build -t georealtor .
  docker run -p 3000:3000 georealtor
  ```
1. Dotenv for easiest configuration of the environment during the deployment process.
