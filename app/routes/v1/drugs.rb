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
          optional :pharmaceutical_form, type: String
          optional :insurance_list, type: String
          optional :issuing, type: String
          optional :atc, type: String
          optional :license_holder, type: String
          # at_least_one_of :registered_name, :active_ingredient,
            # :pharmaceutical_form, :insurance_list, :issuing, :atc, :license_holder
        end
        desc 'Filters Registered Drugs'
        get do
          # check if columns exist
          if params.count > 1
            params.each do |key, _|
              next if key == "user_type"
              unless ActiveRecord::Base.connection.column_exists?(:drugs, key)
                error!({error: "Drug attribute '#{key}' does not exist"})
              end
            end
          end

        # Student and Others cannot change issuing
        if ["Student", "Other"].include?(params[:user_type]) && params.key?(:issuing)
          error!({error: "Students and Others cannot filter by issuing attribute"})
        end

          result = []
          if params.count == 1
            if params["user_type"] == "MD"
              result << Drug.all
            else
              result << Drug.where("issuing = 'BR'")
            end
          elsif params.count == 2
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
            unless params[:user_type] == "MD"
              query << " AND issuing = 'BR'"
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
