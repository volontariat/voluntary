# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150809123803) do

  create_table "areas", force: :cascade do |t|
    t.string   "ancestry",       limit: 255
    t.integer  "ancestry_depth", limit: 4,   default: 0
    t.integer  "position",       limit: 4
    t.string   "name",           limit: 255
    t.string   "slug",           limit: 255
    t.integer  "users_count",    limit: 4,   default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "areas", ["ancestry"], name: "index_areas_on_ancestry", using: :btree
  add_index "areas", ["name"], name: "index_areas_on_name", unique: true, using: :btree
  add_index "areas", ["slug"], name: "index_areas_on_slug", unique: true, using: :btree

  create_table "areas_projects", force: :cascade do |t|
    t.integer "area_id",    limit: 4
    t.integer "project_id", limit: 4
  end

  add_index "areas_projects", ["area_id", "project_id"], name: "index_areas_projects_on_area_id_and_project_id", unique: true, using: :btree
  add_index "areas_projects", ["area_id"], name: "index_areas_projects_on_area_id", using: :btree
  add_index "areas_projects", ["project_id"], name: "index_areas_projects_on_project_id", using: :btree

  create_table "areas_users", force: :cascade do |t|
    t.integer "area_id", limit: 4
    t.integer "user_id", limit: 4
  end

  add_index "areas_users", ["area_id", "user_id"], name: "index_areas_users_on_area_id_and_user_id", unique: true, using: :btree
  add_index "areas_users", ["area_id"], name: "index_areas_users_on_area_id", using: :btree
  add_index "areas_users", ["user_id"], name: "index_areas_users_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "commentable_type", limit: 255
    t.integer  "commentable_id",   limit: 4
    t.integer  "user_id",          limit: 4
    t.string   "ancestry",         limit: 255
    t.integer  "ancestry_depth",   limit: 4,     default: 0
    t.integer  "position",         limit: 4
    t.string   "name",             limit: 255
    t.text     "text",             limit: 65535
    t.string   "state",            limit: 255
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "comments", ["ancestry"], name: "index_comments_on_ancestry", using: :btree
  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "likes", force: :cascade do |t|
    t.boolean  "positive",               default: true
    t.integer  "target_id",   limit: 4
    t.string   "target_type", limit: 60,                null: false
    t.integer  "user_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["target_id", "user_id", "target_type"], name: "index_likes_on_target_id_and_user_id_and_target_type", unique: true, using: :btree

  create_table "list_items", force: :cascade do |t|
    t.integer  "list_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.string   "thing_type", limit: 255
    t.integer  "thing_id",   limit: 4
    t.integer  "position",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "lists", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "lists", ["user_id"], name: "index_lists_on_user_id", using: :btree

  create_table "mongo_db_documents", force: :cascade do |t|
    t.integer  "mongo_db_object_id", limit: 4
    t.string   "klass_name",         limit: 255
    t.string   "name",               limit: 255
    t.string   "slug",               limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "mongo_db_documents", ["mongo_db_object_id", "klass_name"], name: "index_mongo_db_documents_on_mongo_db_object_id_and_klass_name", unique: true, using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "slug",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "user_id",    limit: 4
  end

  add_index "organizations", ["slug"], name: "index_organizations_on_slug", using: :btree

  create_table "professions", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "slug",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.string   "name",            limit: 255
    t.string   "slug",            limit: 255
    t.text     "text",            limit: 65535
    t.string   "url",             limit: 255
    t.string   "state",           limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "product_id",      limit: 255
    t.integer  "organization_id", limit: 4
  end

  add_index "projects", ["organization_id"], name: "index_projects_on_organization_id", using: :btree
  add_index "projects", ["product_id"], name: "index_projects_on_product_id", using: :btree
  add_index "projects", ["slug"], name: "index_projects_on_slug", unique: true, using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "projects_users", force: :cascade do |t|
    t.integer "project_id", limit: 4
    t.integer "user_id",    limit: 4
    t.string  "state",      limit: 255
  end

  add_index "projects_users", ["project_id", "user_id"], name: "index_projects_users_on_project_id_and_user_id", unique: true, using: :btree
  add_index "projects_users", ["project_id"], name: "index_projects_users_on_project_id", using: :btree
  add_index "projects_users", ["user_id"], name: "index_projects_users_on_user_id", using: :btree

  create_table "things", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "things", ["name"], name: "index_things_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.string   "slug",                    limit: 255
    t.string   "rpx_identifier",          limit: 255
    t.string   "password",                limit: 255
    t.text     "text",                    limit: 65535
    t.text     "serialized_private_key",  limit: 65535
    t.string   "language",                limit: 255
    t.string   "first_name",              limit: 255
    t.string   "last_name",               limit: 255
    t.string   "salutation",              limit: 255
    t.string   "marital_status",          limit: 255
    t.string   "family_status",           limit: 255
    t.date     "date_of_birth"
    t.string   "place_of_birth",          limit: 255
    t.string   "citizenship",             limit: 255
    t.string   "encrypted_password",      limit: 255,   default: "", null: false
    t.string   "reset_password_token",    limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",           limit: 4,     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",      limit: 255
    t.string   "last_sign_in_ip",         limit: 255
    t.string   "confirmation_token",      limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",       limit: 255
    t.integer  "failed_attempts",         limit: 4,     default: 0
    t.string   "unlock_token",            limit: 255
    t.datetime "locked_at"
    t.string   "authentication_token",    limit: 255
    t.string   "password_salt",           limit: 255
    t.string   "state",                   limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "country",                 limit: 255
    t.string   "interface_language",      limit: 255
    t.string   "employment_relationship", limit: 255
    t.integer  "profession_id",           limit: 4
    t.text     "foreign_languages",       limit: 65535
    t.string   "email",                   limit: 255
    t.string   "provider",                limit: 255
    t.string   "uid",                     limit: 255
    t.string   "lastfm_user_name",        limit: 255
    t.string   "api_key",                 limit: 32
    t.integer  "roles",                   limit: 8,     default: 0,  null: false
  end

  add_index "users", ["api_key"], name: "index_users_on_api_key", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["profession_id"], name: "index_users_on_profession_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

end
