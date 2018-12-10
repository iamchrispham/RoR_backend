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

ActiveRecord::Schema.define(version: 20160708082142) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "example_notifiables", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "example_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "example_notifiers", ["showoff_sns_notification_id"], name: "index_example_notifiers_on_notification", using: :btree

  create_table "showoff_sns_devices", force: :cascade do |t|
    t.text     "uuid",                                  null: false
    t.string   "platform",                              null: false
    t.boolean  "active",                 default: true
    t.text     "endpoint_arn",                          null: false
    t.text     "push_token",                            null: false
    t.integer  "owner_id",     limit: 8,                null: false
    t.text     "owner_type",                            null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "showoff_sns_devices", ["active", "owner_id", "owner_type"], name: "index_showoff_sns_devices_on_active_and_owner_id_and_owner_type", using: :btree
  add_index "showoff_sns_devices", ["owner_id", "owner_type"], name: "index_showoff_sns_devices_on_owner_id_and_owner_type", using: :btree
  add_index "showoff_sns_devices", ["owner_id"], name: "index_showoff_sns_devices_on_owner_id", using: :btree
  add_index "showoff_sns_devices", ["owner_type"], name: "index_showoff_sns_devices_on_owner_type", using: :btree
  add_index "showoff_sns_devices", ["platform"], name: "index_showoff_sns_devices_on_platform", using: :btree
  add_index "showoff_sns_devices", ["uuid", "owner_id", "owner_type"], name: "index_showoff_sns_devices_on_uuid_and_owner_id_and_owner_type", using: :btree
  add_index "showoff_sns_devices", ["uuid"], name: "index_showoff_sns_devices_on_uuid", using: :btree

  create_table "showoff_sns_notifications", force: :cascade do |t|
    t.integer  "status",                     default: 0, null: false
    t.integer  "subscriber_count"
    t.datetime "sent_at"
    t.integer  "notifier_id",      limit: 8
    t.string   "notifier_type"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "showoff_sns_notifications", ["notifier_id", "notifier_type"], name: "sns_notifications_notifier", using: :btree
  add_index "showoff_sns_notifications", ["notifier_id"], name: "index_showoff_sns_notifications_on_notifier_id", using: :btree
  add_index "showoff_sns_notifications", ["notifier_type"], name: "index_showoff_sns_notifications_on_notifier_type", using: :btree

  create_table "showoff_sns_notified_objects", force: :cascade do |t|
    t.integer  "status",                                  default: 0, null: false
    t.integer  "showoff_sns_notification_id"
    t.integer  "showoff_sns_notified_class_id"
    t.integer  "notifiable_id",                 limit: 8
    t.string   "notifiable_type"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "showoff_sns_notified_objects", ["notifiable_id", "notifiable_type"], name: "sns_notified_object_notifiable", using: :btree
  add_index "showoff_sns_notified_objects", ["notifiable_id"], name: "index_showoff_sns_notified_objects_on_notifiable_id", using: :btree
  add_index "showoff_sns_notified_objects", ["notifiable_type"], name: "index_showoff_sns_notified_objects_on_notifiable_type", using: :btree
  add_index "showoff_sns_notified_objects", ["showoff_sns_notification_id"], name: "sns_notified_object_notification", using: :btree
  add_index "showoff_sns_notified_objects", ["showoff_sns_notified_class_id"], name: "sns_notified_object_notified_class", using: :btree
  add_index "showoff_sns_notified_objects", ["status"], name: "sns_notified_object_status", using: :btree

  add_foreign_key "example_notifiers", "showoff_sns_notifications"
  add_foreign_key "showoff_sns_notified_objects", "showoff_sns_notifications"
end
