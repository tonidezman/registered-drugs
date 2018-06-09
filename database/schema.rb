# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160730195332) do

  create_table "drugs", id: nil, force: :cascade do |t|
    t.string   "registered_name",     null: false
    t.string   "active_ingredient"
    t.string   "pharmaceutical_form"
    t.string   "insurance_list"
    t.string   "issuing"
    t.string   "atc"
    t.string   "license_holder"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["active_ingredient"], name: "index_drugs_on_active_ingredient"
    t.index ["id"], name: "sqlite_autoindex_drugs_1", unique: true
    t.index ["issuing"], name: "index_drugs_on_issuing"
    t.index ["registered_name"], name: "index_drugs_on_registered_name"
  end

end
