module Routes
  module V1
    class Drugs < Grape::API
      desc 'Get a list of 10 Registered Drugs'
      get :drugs do
        present Drug.first(10), with: Entities::V1::Drug
      end
    end
  end
end
