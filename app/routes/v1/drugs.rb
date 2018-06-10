module Routes
  module V1
    class Drugs < Grape::API
      desc 'Get a list of all Registered Drugs'
      get :drugs do
        present Drug.all, with: Entities::V1::Drug
      end

      namespace :search do
        desc "Shows search options and requirements"
        get :help do
          {
            require_user_type: true,
            search_query_by: [:registered_name, :active_ingredient, :pharmaceutical_form, :insurance_list, :issuing, :atc, :license_holder],
            additional_info: "You can do search by one or two attributes"
          }
        end

        params do
          requires :user_type, allow_blank: false, type: String, values: ["Student", "Other", "MD"]
        end
        desc 'Filters Registered Drugs'
        get do
          if params.count > 1 && !Drug.columns_exist?(params)
            error!({error: "Check correctness for drug attributes in the URL"})
          end

          student_or_other_want_to_filter_by_issuing =
            ["Student", "Other"].include?(params[:user_type]) && params.key?(:issuing)
          if student_or_other_want_to_filter_by_issuing
            error!({error: "Students and Others cannot filter by issuing attribute"})
          end

          if params.count == 1
            result = (params["user_type"] == "MD") ? Drug.all : Drug.where("issuing = 'BR'")
          elsif params.count <= 3
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
            unless params[:user_type] == "MD"
              query << " AND issuing = 'BR'"
            end
            result = Drug.where(query, *query_params)
          else
            error!({error: "You can search over one or two attributes"}, 400)
          end
          result
        end
      end
    end
  end
end
