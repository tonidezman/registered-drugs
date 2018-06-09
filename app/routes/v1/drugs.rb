module Routes
  module V1
    class Drugs < Grape::API
      params do
        requires :user_type, allow_blank: false, type: String, values: [
          "Student",
          "Other",
          "MD"
        ]
      end
      desc 'Get a list of all Registered Drugs'
      get :drugs do
        if ["Student", "other"].include? params[:user_type]
          query = Drug.where(issuing: "BR")
        else
          query = Drug.all
        end

        # TODO write this code when you have tests
        # present Drug.get_drugs(user_type), with: Entities::V1::Drug
        present query, with: Entities::V1::Drug
      end

      namespace :search do
        get :help do
          {
            require_user_type: true,
            search_query_by: [:registered_name, :active_ingredient, :issuing],
            additional_info: "You can do search by one or two attributes"
          }
        end

        params do
          requires :user_type, allow_blank: false, type: String, values: [
            "Student",
            "Other",
            "MD"
          ]
          optional :registered_name, type: String
          optional :active_ingredient, type: String
          optional :issuing, type: String
          at_least_one_of :registered_name, :active_ingredient, :issuing
        end
        desc 'Filters Registered Drugs'
        get do
          result = []
          if params.count == 2
            params.each do |key, value|
              next if key == "user_type"
              if params[:user_type] == "MD"
                result << Drug.where("#{key} LIKE ?", "%#{value}%")
              else
                result << Drug.where("#{key} LIKE ?", "%#{value}% AND issuing = 'BR'")
              end
            end
          elsif params.count == 3
            query = ""
            query_params = []
            params.each do |key, value|
              next if key == "user_type"
              if query.empty?
                query << "#{key} LIKE ? "
                query_params << "%#{value}%"
              else
                query << "AND #{key} LIKE ?"
                query_params << "%#{value}%"
              end
            end
            result << Drug.where(query, query_params[0], query_params[1])
          else
            error!({error: "You can search over one or two attributes"}, 400)
          end
          result.flatten
        end
      end
    end
  end
end
