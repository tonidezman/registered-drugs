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
            error!({ error: "Check correctness for drug attributes in the URL" })
          end

          student_or_other_want_to_filter_by_issuing = ["Student", "Other"].include?(params[:user_type]) && params.key?(:issuing)
          if student_or_other_want_to_filter_by_issuing
            error!({ error: "Students and Others cannot filter by issuing attribute" })
          end

          only_user_type_param_given = params.count == 1
          additional_params_given = params.count <= 3
          if only_user_type_param_given
            query = (params["user_type"] == "MD") ? "issuing != 'BR'" : "issuing = 'BR'"
            result = Drug.where(query)
          elsif additional_params_given
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
            query << ((params[:user_type] == "MD") ? " AND issuing != 'BR'" : " AND issuing = 'BR'")
            result = Drug.where(query, *query_params)
          else
            error!({ error: "You cannot filter with more than two parameters" }, 400)
          end
          result
        end
      end
    end
  end
end
