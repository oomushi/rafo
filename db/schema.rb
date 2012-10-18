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

ActiveRecord::Schema.define(:version => 20121018173251) do

  create_table "blobs", :force => true do |t|
    t.string   "content_type"
    t.binary   "file"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "icons", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "blob_id"
  end

  create_table "images", :force => true do |t|
    t.integer  "uy_id"
    t.integer  "ul_id"
    t.integer  "ux_id"
    t.integer  "ur_id"
    t.integer  "ly_id"
    t.integer  "lx_id"
    t.integer  "cx_id"
    t.integer  "rx_id"
    t.integer  "ry_id"
    t.integer  "dl_id"
    t.integer  "dx_id"
    t.integer  "dr_id"
    t.integer  "dy_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "quotes", :force => true do |t|
    t.integer  "user_id"
    t.string   "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "username"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
