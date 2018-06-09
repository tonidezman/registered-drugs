module Entities
  module V1
    class Drug < Grape::Entity
      expose :id, documentation: {type: 'string'}
      expose :registered_name, documentation: {type: 'string', desc: "Registered drug name"}
    end
  end
end
