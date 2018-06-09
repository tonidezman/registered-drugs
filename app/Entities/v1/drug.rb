module Entities
  module V1
    class Drug < Grape::Entity
      expose :id, documentation: {type: 'string'}
      expose :name, documentation: {type: 'string', desc: "Registered drug name"}
    end
  end
end
