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

ActiveRecord::Schema.define(version: 20170905144433) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "repositories", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "html_url"
    t.integer "stargazers_count"
    t.integer "forks_count"
    t.integer "user_id"
    t.datetime "pushed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "repo_created_at", null: false
    t.string "topics", default: [], null: false, array: true
    t.string "name_with_owner", null: false
    t.string "url", null: false
    t.index ["name_with_owner"], name: "index_repositories_on_name_with_owner", unique: true
    t.index ["pushed_at"], name: "index_repositories_on_pushed_at"
    t.index ["user_id"], name: "index_repositories_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "login", null: false
    t.string "html_url"
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login"], name: "index_users_on_login", unique: true
  end

  add_foreign_key "repositories", "users"
end
