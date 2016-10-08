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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20161008101010) do

  create_table "compilers", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "language_id"
    t.string   "image_id"
    t.string   "run_config"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "container_stacks", :force => true do |t|
    t.string   "name"
    t.integer  "image_type"
    t.integer  "language_id"
    t.integer  "compiler_id"
    t.string   "image_id"
    t.integer  "count"
    t.string   "dependency"
    t.integer  "status"
    t.integer  "created_by"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "containers", :force => true do |t|
    t.integer  "type"
    t.integer  "stack_id"
    t.string   "host"
    t.integer  "port"
    t.string   "image_id"
    t.integer  "status"
    t.integer  "assigned_to"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "contents", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "desc"
    t.text     "content"
    t.integer  "file_type"
    t.integer  "compile"
    t.integer  "status"
    t.integer  "sharability"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "template"
    t.integer  "template_cat"
    t.text     "output_text"
    t.integer  "view_count"
    t.integer  "like_count"
    t.integer  "folder_id",    :default => 0
  end

  create_table "folders", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "image_configs", :force => true do |t|
    t.integer  "image_type"
    t.integer  "image_id"
    t.text     "dockerfile"
    t.text     "startup_config"
    t.string   "access_config"
    t.integer  "default_port"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "how_to"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "likes", :force => true do |t|
    t.integer  "obj_type"
    t.integer  "obj_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "networks", :force => true do |t|
    t.string   "name"
    t.integer  "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "packages", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "type"
    t.string   "image_id"
    t.string   "version"
    t.string   "access"
    t.string   "how_to"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "user_compiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "content_id"
    t.integer  "language_id"
    t.integer  "compiler_id"
    t.integer  "status"
    t.string   "dependency"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "is_admin",               :default => 0,  :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "last_open_file"
    t.integer  "default_font_size"
    t.integer  "default_theme"
    t.string   "unique_key"
    t.integer  "default_keybind"
    t.string   "dropbox_uid"
    t.string   "dropbox_access_token"
    t.integer  "dropbox_sync_status"
    t.datetime "dropbox_last_sync_at"
    t.string   "url_name"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
