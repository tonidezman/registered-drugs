# Registered Drugs app

### Running your local server
- clone the repo
- `bundle install`
- `rake db:migrate`
- `rake db:seed`
- `shotgun`

Go 127.0.0.1:9393 in your favorite Browser
- checkout routes folder for all available paths

### Run tests
- `RACK_ENV=test rake db:migrate`
- `rake test`

**NOTE:** if you have trouble running commands in the terminal try to prepend `bundle exec` before the command

### Swagger API documentation
- http://localhost:9393/v1/swagger_doc
- http://petstore.swagger.io/?url=http://localhost:9393/v1/swagger_doc#/