require 'grape-swagger'
module Routes
  module V1
    class API < Grape::API
      version 'v1'
      format :json
      mount Routes::V1::Drugs
      add_swagger_documentation info: { title: 'Registered Drugs API'}
    end
  end
end
