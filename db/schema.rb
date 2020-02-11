# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_11_043825) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories_claims", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "claim_id", null: false
    t.index ["category_id"], name: "index_categories_claims_on_category_id"
    t.index ["claim_id"], name: "index_categories_claims_on_claim_id"
  end

  create_table "claims", force: :cascade do |t|
    t.string "statement"
    t.string "speaker_name"
    t.string "speaker_title"
    t.date "date"
    t.string "location"
    t.string "publisher_name"
    t.uuid "fact_stream_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "checked", default: false
  end
end
