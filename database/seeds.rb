require 'csv'

Drug.destroy_all

CSV.foreach('database/rs_drugs_1000.csv', headers: true) do |registered_drug|
  drug = Drug.new
  drug.id = registered_drug["id"]
  drug.registered_name = registered_drug["registered_name"]
  drug.active_ingredient = registered_drug["active_ingredient"]
  drug.pharmaceutical_form = registered_drug["pharmaceutical_form"]
  drug.insurance_list = registered_drug["insurance_list"]
  drug.issuing = registered_drug["issuing"]
  drug.atc = registered_drug["atc"]
  drug.license_holder = registered_drug["license_holder"]
  drug.save!
end

puts "Saved #{Drug.count} Registered Drugs."