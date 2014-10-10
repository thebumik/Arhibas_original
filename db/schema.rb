# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100121102224) do

  create_table "assets", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assetable_id"
    t.string   "assetable_type"
  end

  add_index "assets", ["assetable_id"], :name => "index_assets_on_assetable_id"
  add_index "assets", ["assetable_type"], :name => "index_assets_on_assetable_type"

  create_table "categories", :force => true do |t|
    t.integer  "position"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.boolean  "published",   :default => true
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "stage"
  end

  add_index "categories", ["lft", "rgt"], :name => "index_categories_on_lft_and_rgt"
  add_index "categories", ["lft"], :name => "index_categories_on_lft"
  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"
  add_index "categories", ["rgt"], :name => "index_categories_on_rgt"

  create_table "comments", :force => true do |t|
    t.string   "author"
    t.boolean  "active",     :default => false
    t.text     "body"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["project_id"], :name => "index_comments_on_project_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.text     "body"
    t.text     "body_markdown"
    t.integer  "position"
    t.boolean  "published",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  create_table "photos", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  add_index "photos", ["project_id"], :name => "index_photos_on_project_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "customer"
    t.string   "location"
    t.string   "arhitect"
    t.integer  "completion"
    t.integer  "position"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",                                        :default => true
    t.integer  "category_id"
    t.decimal  "rating_avg",        :precision => 10, :scale => 2, :default => 0.0
    t.integer  "rating_total",                                     :default => 0
    t.integer  "rating_last_value"
    t.text     "body"
    t.text     "body_markdown"
    t.boolean  "in_sidebar",                                       :default => true
  end

  add_index "projects", ["category_id"], :name => "index_projects_on_category_id"

  create_table "settings", :force => true do |t|
    t.string   "var",        :null => false
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["var"], :name => "index_settings_on_var"

  create_table "translations", :force => true do |t|
    t.string  "name"
    t.string  "customer"
    t.string  "location"
    t.string  "arhitect"
    t.text    "description"
    t.integer "translationable_id"
    t.string  "translationable_type"
    t.string  "lang"
    t.text    "body"
    t.text    "body_markdown"
  end

  add_index "translations", ["lang"], :name => "index_translations_on_lang"
  add_index "translations", ["translationable_id"], :name => "index_translations_on_translationable_id"
  add_index "translations", ["translationable_type"], :name => "index_translations_on_translationable_type"

  create_table "users", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
  end

  create_table "votes", :force => true do |t|
    t.string   "ip"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["project_id"], :name => "index_votes_on_project_id"

end
