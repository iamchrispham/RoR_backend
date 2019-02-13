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

ActiveRecord::Schema.define(version: 20190213133023) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "addresses", force: :cascade do |t|
    t.integer  "user_id",                     null: false
    t.string   "country_code",                null: false
    t.string   "line1"
    t.string   "line2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.boolean  "active",       default: true, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "addresses", ["active"], name: "index_addresses_on_active", using: :btree
  add_index "addresses", ["country_code"], name: "index_addresses_on_country_code", using: :btree
  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "admin_roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_roles", ["name", "resource_type", "resource_id"], name: "index_admin_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "admin_roles", ["name"], name: "index_admin_roles_on_name", using: :btree

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.datetime "date_of_birth"
    t.string   "facebook_uid"
    t.string   "facebook_access_token"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.boolean  "notifications_enabled",  default: true, null: false
    t.boolean  "active",                 default: true, null: false
  end

  add_index "admins", ["active"], name: "index_admins_on_active", using: :btree
  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["invitation_token"], name: "index_admins_on_invitation_token", unique: true, using: :btree
  add_index "admins", ["invitations_count"], name: "index_admins_on_invitations_count", using: :btree
  add_index "admins", ["invited_by_id"], name: "index_admins_on_invited_by_id", using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "admins_admin_roles", id: false, force: :cascade do |t|
    t.integer "admin_id"
    t.integer "admin_role_id"
  end

  add_index "admins_admin_roles", ["admin_id", "admin_role_id"], name: "index_admins_admin_roles_on_admin_id_and_admin_role_id", using: :btree

  create_table "blazer_audits", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "query_id"
    t.text     "statement"
    t.string   "data_source"
    t.datetime "created_at"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.integer  "creator_id"
    t.integer  "query_id"
    t.string   "state"
    t.string   "schedule"
    t.text     "emails"
    t.string   "check_type"
    t.text     "message"
    t.datetime "last_run_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.integer  "dashboard_id"
    t.integer  "query_id"
    t.integer  "position"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.integer  "creator_id"
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.integer  "creator_id"
    t.string   "name"
    t.text     "description"
    t.text     "statement"
    t.string   "data_source"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "companies", force: :cascade do |t|
    t.integer  "user_id",                                null: false
    t.string   "title",                                  null: false
    t.text     "description"
    t.string   "phone_number"
    t.string   "email"
    t.string   "facebook_profile_link"
    t.string   "linkedin_profile_link"
    t.string   "instagram_profile_link"
    t.string   "snapchat_profile_link"
    t.string   "website_link"
    t.string   "location"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "country_code"
    t.boolean  "active",                 default: true,  null: false
    t.boolean  "suspended",              default: false, null: false
    t.text     "categories"
  end

  add_index "companies", ["title"], name: "index_companies_on_title", using: :btree

  create_table "contact_invites", force: :cascade do |t|
    t.integer  "user_id",      null: false
    t.integer  "event_id"
    t.integer  "go_user_id"
    t.string   "email"
    t.string   "phone_number"
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "contact_invites", ["email"], name: "index_contact_invites_on_email", using: :btree
  add_index "contact_invites", ["event_id"], name: "index_contact_invites_on_event_id", using: :btree
  add_index "contact_invites", ["go_user_id"], name: "index_contact_invites_on_go_user_id", using: :btree
  add_index "contact_invites", ["name"], name: "index_contact_invites_on_name", using: :btree
  add_index "contact_invites", ["phone_number"], name: "index_contact_invites_on_phone_number", using: :btree
  add_index "contact_invites", ["user_id", "go_user_id", "event_id", "email", "phone_number"], name: "idx_contact_invite_unique", unique: true, using: :btree
  add_index "contact_invites", ["user_id"], name: "index_contact_invites_on_user_id", using: :btree

# Could not dump table "contacts" because of following StandardError
#   Unknown type 'contact_category' for column 'category'

  create_table "conversation_participants", force: :cascade do |t|
    t.string   "participant_type"
    t.integer  "participant_id"
    t.boolean  "muted",            default: false
    t.boolean  "activated",        default: true
    t.integer  "conversation_id",                  null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "conversation_participants", ["conversation_id"], name: "index_conversation_participants_on_conversation_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.string   "name"
    t.string   "purpose"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "event_id"
    t.boolean  "activated",          default: true
    t.integer  "owner_id"
    t.string   "owner_type"
  end

  add_index "conversations", ["event_id"], name: "index_conversations_on_event_id", using: :btree
  add_index "conversations", ["owner_type", "owner_id"], name: "index_conversations_on_owner_type_and_owner_id", using: :btree

  create_table "developers", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name",                            null: false
    t.string   "last_name",                             null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "active",                 default: true, null: false
    t.datetime "last_active"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "developers", ["active"], name: "index_developers_on_active", using: :btree
  add_index "developers", ["email"], name: "index_developers_on_email", unique: true, using: :btree
  add_index "developers", ["last_active"], name: "index_developers_on_last_active", using: :btree
  add_index "developers", ["reset_password_token"], name: "index_developers_on_reset_password_token", unique: true, using: :btree

  create_table "event_attendee_contributions", force: :cascade do |t|
    t.integer  "event_attendee_id",                null: false
    t.integer  "amount_cents",      default: 0,    null: false
    t.boolean  "active",            default: true, null: false
    t.integer  "status",            default: 0,    null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "event_attendee_contributions", ["active"], name: "index_event_attendee_contributions_on_active", using: :btree
  add_index "event_attendee_contributions", ["event_attendee_id"], name: "index_event_attendee_contributions_on_event_attendee_id", using: :btree
  add_index "event_attendee_contributions", ["status"], name: "index_event_attendee_contributions_on_status", using: :btree

  create_table "event_attendee_request_owner_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id",           null: false
    t.integer  "event_attendee_request_id",             null: false
    t.string   "owner_type",                            null: false
    t.integer  "owner_id",                    limit: 8, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "event_attendee_request_owner_notifiers", ["owner_id", "owner_type"], name: "index_event_attendee_request_owner_notifiers_on_owner", using: :btree
  add_index "event_attendee_request_owner_notifiers", ["owner_id"], name: "index_event_attendee_request_owner_notifiers_on_owner_id", using: :btree
  add_index "event_attendee_request_owner_notifiers", ["owner_type"], name: "index_event_attendee_request_owner_notifiers_on_owner_type", using: :btree
  add_index "event_attendee_request_owner_notifiers", ["showoff_sns_notification_id"], name: "index_event_attendee_request_owner_notifiers_on_notification", using: :btree

  create_table "event_attendee_request_response_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id",           null: false
    t.integer  "event_attendee_request_id",             null: false
    t.string   "owner_type",                            null: false
    t.integer  "owner_id",                    limit: 8, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "event_attendee_request_response_notifiers", ["owner_id", "owner_type"], name: "index_event_attendee_request_response_notifiers_on_owner", using: :btree
  add_index "event_attendee_request_response_notifiers", ["owner_id"], name: "index_event_attendee_request_response_notifiers_on_owner_id", using: :btree
  add_index "event_attendee_request_response_notifiers", ["owner_type"], name: "index_event_attendee_request_response_notifiers_on_owner_type", using: :btree
  add_index "event_attendee_request_response_notifiers", ["showoff_sns_notification_id"], name: "index_event_attendee_request_response_notifiers_on_notification", using: :btree

  create_table "event_attendee_requests", force: :cascade do |t|
    t.integer  "event_attendee_id",             null: false
    t.integer  "status",            default: 0, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "event_attendee_requests", ["event_attendee_id"], name: "index_event_attendee_requests_on_event_attendee_id", using: :btree
  add_index "event_attendee_requests", ["status"], name: "index_event_attendee_requests_on_status", using: :btree

  create_table "event_attendees", force: :cascade do |t|
    t.integer  "event_id",                   null: false
    t.integer  "user_id",                    null: false
    t.integer  "status",     default: 0,     null: false
    t.boolean  "invited",    default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "event_attendees", ["event_id"], name: "index_event_attendees_on_event_id", using: :btree
  add_index "event_attendees", ["invited"], name: "index_event_attendees_on_invited", using: :btree
  add_index "event_attendees", ["status"], name: "index_event_attendees_on_status", using: :btree
  add_index "event_attendees", ["user_id"], name: "index_event_attendees_on_user_id", using: :btree

  create_table "event_cancelled_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id",           null: false
    t.integer  "event_id",                              null: false
    t.string   "owner_type",                            null: false
    t.integer  "owner_id",                    limit: 8, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "event_cancelled_notifiers", ["event_id"], name: "index_event_cancelled_notifiers_on_event_id", using: :btree
  add_index "event_cancelled_notifiers", ["owner_id", "owner_type"], name: "index_event_cancelled_notifiers_on_owner_id_and_owner_type", using: :btree
  add_index "event_cancelled_notifiers", ["owner_id"], name: "index_event_cancelled_notifiers_on_owner_id", using: :btree
  add_index "event_cancelled_notifiers", ["owner_type"], name: "index_event_cancelled_notifiers_on_owner_type", using: :btree
  add_index "event_cancelled_notifiers", ["showoff_sns_notification_id"], name: "index_event_cancelled_notifiers_on_notification", using: :btree

  create_table "event_contribution_details", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "event_contribution_type_id"
    t.integer  "amount_cents",               default: 0,    null: false
    t.text     "reason"
    t.boolean  "optional",                                  null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "active",                     default: true, null: false
  end

  add_index "event_contribution_details", ["active"], name: "index_event_contribution_details_on_active", using: :btree
  add_index "event_contribution_details", ["event_contribution_type_id"], name: "index_event_contribution_details_on_event_contribution_type_id", using: :btree
  add_index "event_contribution_details", ["event_id"], name: "index_event_contribution_details_on_event_id", using: :btree
  add_index "event_contribution_details", ["optional"], name: "index_event_contribution_details_on_optional", using: :btree

  create_table "event_contribution_types", force: :cascade do |t|
    t.string   "name",                                     null: false
    t.string   "slug",                                     null: false
    t.string   "cta_title",                                null: false
    t.text     "cta_description",                          null: false
    t.string   "change_amount_title",                      null: false
    t.text     "change_amount_description",                null: false
    t.boolean  "active",                    default: true, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "event_contribution_types", ["active"], name: "index_event_contribution_types_on_active", using: :btree

  create_table "event_invitation_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id",           null: false
    t.integer  "event_attendee_id",                     null: false
    t.string   "owner_type",                            null: false
    t.integer  "owner_id",                    limit: 8, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "event_invitation_notifiers", ["event_attendee_id"], name: "index_event_invitation_notifiers_on_event_attendee_id", using: :btree
  add_index "event_invitation_notifiers", ["owner_id", "owner_type"], name: "index_event_invitation_notifiers_on_owner_id_and_owner_type", using: :btree
  add_index "event_invitation_notifiers", ["owner_id"], name: "index_event_invitation_notifiers_on_owner_id", using: :btree
  add_index "event_invitation_notifiers", ["owner_type"], name: "index_event_invitation_notifiers_on_owner_type", using: :btree
  add_index "event_invitation_notifiers", ["showoff_sns_notification_id"], name: "index_event_invitation_notifiers_on_notification", using: :btree

  create_table "event_media_items", force: :cascade do |t|
    t.integer  "event_id",                          null: false
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "active",             default: true, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "uploaded_url"
    t.string   "media_type"
  end

  add_index "event_media_items", ["active"], name: "index_event_media_items_on_active", using: :btree
  add_index "event_media_items", ["event_id"], name: "index_event_media_items_on_event_id", using: :btree

  create_table "event_owner_attendee_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id",           null: false
    t.integer  "event_attendee_id",                     null: false
    t.string   "owner_type",                            null: false
    t.integer  "owner_id",                    limit: 8, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "event_owner_attendee_notifiers", ["event_attendee_id"], name: "index_event_owner_attendee_notifiers_on_event_attendee_id", using: :btree
  add_index "event_owner_attendee_notifiers", ["owner_id", "owner_type"], name: "index_event_owner_attendee_notifiers_on_owner_id_and_owner_type", using: :btree
  add_index "event_owner_attendee_notifiers", ["owner_id"], name: "index_event_owner_attendee_notifiers_on_owner_id", using: :btree
  add_index "event_owner_attendee_notifiers", ["owner_type"], name: "index_event_owner_attendee_notifiers_on_owner_type", using: :btree
  add_index "event_owner_attendee_notifiers", ["showoff_sns_notification_id"], name: "index_event_owner_attendee_notifiers_on_notification", using: :btree

  create_table "event_share_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id",           null: false
    t.integer  "event_share_id",                        null: false
    t.string   "owner_type",                            null: false
    t.integer  "owner_id",                    limit: 8, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "event_share_notifiers", ["event_share_id"], name: "index_event_share_notifiers_on_event_share_id", using: :btree
  add_index "event_share_notifiers", ["owner_id", "owner_type"], name: "index_event_share_notifiers_on_owner_id_and_owner_type", using: :btree
  add_index "event_share_notifiers", ["owner_id"], name: "index_event_share_notifiers_on_owner_id", using: :btree
  add_index "event_share_notifiers", ["owner_type"], name: "index_event_share_notifiers_on_owner_type", using: :btree
  add_index "event_share_notifiers", ["showoff_sns_notification_id"], name: "index_event_share_notifiers_on_notification", using: :btree

  create_table "event_share_users", force: :cascade do |t|
    t.integer  "user_id",        null: false
    t.integer  "event_share_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "event_share_users", ["event_share_id"], name: "index_event_share_users_on_event_share_id", using: :btree
  add_index "event_share_users", ["user_id"], name: "index_event_share_users_on_user_id", using: :btree

  create_table "event_shares", force: :cascade do |t|
    t.integer  "user_id",                   null: false
    t.integer  "event_id",                  null: false
    t.boolean  "active",     default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "event_shares", ["active"], name: "index_event_shares_on_active", using: :btree
  add_index "event_shares", ["event_id"], name: "index_event_shares_on_event_id", using: :btree
  add_index "event_shares", ["user_id"], name: "index_event_shares_on_user_id", using: :btree

  create_table "event_ticket_detail_views", force: :cascade do |t|
    t.integer  "event_ticket_detail_id",                null: false
    t.integer  "user_id",                               null: false
    t.boolean  "active",                 default: true, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "event_ticket_detail_views", ["active"], name: "index_event_ticket_detail_views_on_active", using: :btree
  add_index "event_ticket_detail_views", ["event_ticket_detail_id"], name: "index_event_ticket_detail_views_on_event_ticket_detail_id", using: :btree
  add_index "event_ticket_detail_views", ["user_id"], name: "index_event_ticket_detail_views_on_user_id", using: :btree

  create_table "event_ticket_details", force: :cascade do |t|
    t.integer  "event_id"
    t.text     "url",                       null: false
    t.boolean  "active",     default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "event_ticket_details", ["active"], name: "index_event_ticket_details_on_active", using: :btree
  add_index "event_ticket_details", ["event_id"], name: "index_event_ticket_details_on_event_id", using: :btree

  create_table "event_timeline_item_comment_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id",              null: false
    t.integer  "event_timeline_item_comment_id",           null: false
    t.string   "owner_type",                               null: false
    t.integer  "owner_id",                       limit: 8, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "event_timeline_item_comment_notifiers", ["event_timeline_item_comment_id"], name: "index_event_timeline_item_on_event_timeline_item_comment", using: :btree
  add_index "event_timeline_item_comment_notifiers", ["owner_id", "owner_type"], name: "index_event_timeline_item_comment_notifiers_on_owner", using: :btree
  add_index "event_timeline_item_comment_notifiers", ["owner_id"], name: "index_event_timeline_item_comment_notifiers_on_owner_id", using: :btree
  add_index "event_timeline_item_comment_notifiers", ["owner_type"], name: "index_event_timeline_item_comment_notifiers_on_owner_type", using: :btree
  add_index "event_timeline_item_comment_notifiers", ["showoff_sns_notification_id"], name: "index_event_timeline_item_comment_notifiers_on_notification", using: :btree

  create_table "event_timeline_item_comments", force: :cascade do |t|
    t.integer  "user_id",                               null: false
    t.integer  "event_timeline_item_id",                null: false
    t.text     "content",                               null: false
    t.datetime "inactive_at"
    t.boolean  "active",                 default: true, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "event_timeline_item_comments", ["active"], name: "index_event_timeline_item_comments_on_active", using: :btree
  add_index "event_timeline_item_comments", ["event_timeline_item_id"], name: "index_event_timeline_item_comments_on_event_timeline_item_id", using: :btree
  add_index "event_timeline_item_comments", ["user_id"], name: "index_event_timeline_item_comments_on_user_id", using: :btree

  create_table "event_timeline_item_like_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id",           null: false
    t.integer  "event_timeline_item_like_id",           null: false
    t.string   "owner_type",                            null: false
    t.integer  "owner_id",                    limit: 8, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "event_timeline_item_like_notifiers", ["event_timeline_item_like_id"], name: "index_event_timeline_item_like_on_event_timeline_item_like", using: :btree
  add_index "event_timeline_item_like_notifiers", ["owner_id", "owner_type"], name: "index_event_timeline_item_like_notifiers_on_owner", using: :btree
  add_index "event_timeline_item_like_notifiers", ["owner_id"], name: "index_event_timeline_item_like_notifiers_on_owner_id", using: :btree
  add_index "event_timeline_item_like_notifiers", ["owner_type"], name: "index_event_timeline_item_like_notifiers_on_owner_type", using: :btree
  add_index "event_timeline_item_like_notifiers", ["showoff_sns_notification_id"], name: "index_event_timeline_item_like_notifiers_on_notification", using: :btree

  create_table "event_timeline_item_likes", force: :cascade do |t|
    t.integer  "user_id",                null: false
    t.integer  "event_timeline_item_id", null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "event_timeline_item_likes", ["event_timeline_item_id"], name: "index_event_timeline_item_likes_on_event_timeline_item_id", using: :btree
  add_index "event_timeline_item_likes", ["user_id"], name: "index_event_timeline_item_likes_on_user_id", using: :btree

  create_table "event_timeline_item_media_items", force: :cascade do |t|
    t.integer  "event_timeline_item_id",                null: false
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "active",                 default: true, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.text     "uploaded_url"
    t.string   "media_type"
    t.string   "text"
  end

  add_index "event_timeline_item_media_items", ["active"], name: "index_event_timeline_item_media_items_on_active", using: :btree
  add_index "event_timeline_item_media_items", ["event_timeline_item_id"], name: "index_event_timeline_item_media_items_on_event_timeline_item_id", using: :btree

  create_table "event_timeline_items", force: :cascade do |t|
    t.integer  "user_id",                           null: false
    t.integer  "event_id",                          null: false
    t.boolean  "active",             default: true, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "number_of_likes",    default: 0,    null: false
    t.integer  "number_of_comments", default: 0,    null: false
    t.datetime "inactive_at"
  end

  add_index "event_timeline_items", ["active"], name: "index_event_timeline_items_on_active", using: :btree
  add_index "event_timeline_items", ["event_id"], name: "index_event_timeline_items_on_event_id", using: :btree
  add_index "event_timeline_items", ["user_id"], name: "index_event_timeline_items_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "title",                                          null: false
    t.text     "description"
    t.datetime "time",                                           null: false
    t.datetime "date",                                           null: false
    t.boolean  "eighteen_plus",                  default: false, null: false
    t.float    "latitude",                                       null: false
    t.float    "longitude",                                      null: false
    t.string   "address",                        default: "",    null: false
    t.string   "country_code"
    t.string   "country",                        default: ""
    t.string   "city",                           default: ""
    t.string   "state",                          default: ""
    t.string   "postal_code",                    default: ""
    t.boolean  "private_event",                  default: false, null: false
    t.text     "categories",                                     null: false
    t.boolean  "event_forwarding",               default: true,  null: false
    t.boolean  "allow_chat",                     default: true,  null: false
    t.boolean  "show_timeline",                  default: true,  null: false
    t.text     "bring"
    t.datetime "inactive_at"
    t.boolean  "active",                         default: true,  null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.text     "facebook_id"
    t.integer  "maximum_attendees"
    t.boolean  "attendance_acceptance_required", default: false
    t.text     "display_address"
    t.datetime "date_time"
    t.integer  "price"
    t.integer  "event_ownerable_id"
    t.string   "event_ownerable_type"
    t.integer  "review_status"
  end

  add_index "events", ["active"], name: "index_events_on_active", using: :btree
  add_index "events", ["attendance_acceptance_required"], name: "index_events_on_attendance_acceptance_required", using: :btree
  add_index "events", ["country_code"], name: "index_events_on_country_code", using: :btree
  add_index "events", ["eighteen_plus"], name: "index_events_on_eighteen_plus", using: :btree
  add_index "events", ["event_ownerable_id", "event_ownerable_type"], name: "index_events_on_event_ownerable_id_and_event_ownerable_type", using: :btree
  add_index "events", ["facebook_id"], name: "index_events_on_facebook_id", using: :btree
  add_index "events", ["inactive_at"], name: "index_events_on_inactive_at", using: :btree
  add_index "events", ["maximum_attendees"], name: "index_events_on_maximum_attendees", using: :btree
  add_index "events", ["price"], name: "index_events_on_price", using: :btree
  add_index "events", ["title"], name: "index_events_on_title", using: :btree

  create_table "feed_item_action_translations", force: :cascade do |t|
    t.integer  "feed_item_action_id", null: false
    t.string   "locale",              null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "action"
  end

  add_index "feed_item_action_translations", ["feed_item_action_id"], name: "index_feed_item_action_translations_on_feed_item_action_id", using: :btree
  add_index "feed_item_action_translations", ["locale"], name: "index_feed_item_action_translations_on_locale", using: :btree

  create_table "feed_item_actions", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.boolean  "active",     default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "feed_item_actions", ["active"], name: "index_feed_item_actions_on_active", using: :btree

  create_table "feed_item_contexts", force: :cascade do |t|
    t.integer  "feed_item_action_id", null: false
    t.integer  "actor_id",            null: false
    t.string   "actor_type",          null: false
    t.integer  "object_id",           null: false
    t.string   "object_type",         null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "feed_item_contexts", ["actor_type", "actor_id"], name: "index_feed_item_contexts_on_actor_type_and_actor_id", using: :btree
  add_index "feed_item_contexts", ["feed_item_action_id"], name: "index_feed_item_contexts_on_feed_item_action_id", using: :btree
  add_index "feed_item_contexts", ["object_type", "object_id"], name: "index_feed_item_contexts_on_object_type_and_object_id", using: :btree

  create_table "feed_items", force: :cascade do |t|
    t.integer  "feed_item_context_id",                null: false
    t.integer  "object_id",                           null: false
    t.string   "object_type",                         null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "active",               default: true, null: false
  end

  add_index "feed_items", ["feed_item_context_id"], name: "index_feed_items_on_feed_item_context_id", using: :btree
  add_index "feed_items", ["object_type", "object_id"], name: "index_feed_items_on_object_type_and_object_id", using: :btree

  create_table "friend_request_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id",           null: false
    t.integer  "friend_request_id",                     null: false
    t.string   "owner_type",                            null: false
    t.integer  "owner_id",                    limit: 8, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "friend_request_notifiers", ["friend_request_id"], name: "index_friend_request_notifiers_on_friend_request_id", using: :btree
  add_index "friend_request_notifiers", ["owner_id", "owner_type"], name: "index_friend_request_notifiers_on_owner_id_and_owner_type", using: :btree
  add_index "friend_request_notifiers", ["owner_id"], name: "index_friend_request_notifiers_on_owner_id", using: :btree
  add_index "friend_request_notifiers", ["owner_type"], name: "index_friend_request_notifiers_on_owner_type", using: :btree
  add_index "friend_request_notifiers", ["showoff_sns_notification_id"], name: "index_friend_request_notifiers_on_notification", using: :btree

  create_table "friend_requests", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "friend_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "friend_requests", ["friend_id"], name: "index_friend_requests_on_friend_id", using: :btree
  add_index "friend_requests", ["user_id"], name: "index_friend_requests_on_user_id", using: :btree

  create_table "friendship_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id",           null: false
    t.integer  "friendship_id",                         null: false
    t.string   "owner_type",                            null: false
    t.integer  "owner_id",                    limit: 8, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "friendship_notifiers", ["friendship_id"], name: "index_friendship_notifiers_on_friendship_id", using: :btree
  add_index "friendship_notifiers", ["owner_id", "owner_type"], name: "index_friendship_notifiers_on_owner_id_and_owner_type", using: :btree
  add_index "friendship_notifiers", ["owner_id"], name: "index_friendship_notifiers_on_owner_id", using: :btree
  add_index "friendship_notifiers", ["owner_type"], name: "index_friendship_notifiers_on_owner_type", using: :btree
  add_index "friendship_notifiers", ["showoff_sns_notification_id"], name: "index_friendship_notifiers_on_notification", using: :btree

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "friend_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "friendships", ["friend_id"], name: "index_friendships_on_friend_id", using: :btree
  add_index "friendships", ["user_id"], name: "index_friendships_on_user_id", using: :btree

  create_table "general_notification_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id",           null: false
    t.integer  "general_notification_id",               null: false
    t.string   "owner_type",                            null: false
    t.integer  "owner_id",                    limit: 8, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "general_notification_notifiers", ["general_notification_id"], name: "index_general_notification_notifiers_on_general_notification_id", using: :btree
  add_index "general_notification_notifiers", ["owner_id", "owner_type"], name: "index_general_notification_notifiers_on_owner", using: :btree
  add_index "general_notification_notifiers", ["owner_id"], name: "index_general_notification_notifiers_on_owner_id", using: :btree
  add_index "general_notification_notifiers", ["owner_type"], name: "index_general_notification_notifiers_on_owner_type", using: :btree
  add_index "general_notification_notifiers", ["showoff_sns_notification_id"], name: "index_general_notification_notifiers_on_notification", using: :btree

  create_table "general_notification_users", force: :cascade do |t|
    t.integer  "user_id",                 null: false
    t.integer  "general_notification_id", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "general_notification_users", ["general_notification_id"], name: "index_general_notification_users_on_general_notification_id", using: :btree
  add_index "general_notification_users", ["user_id"], name: "index_general_notification_users_on_user_id", using: :btree

  create_table "general_notifications", force: :cascade do |t|
    t.string   "title",                        null: false
    t.text     "message",                      null: false
    t.integer  "owner_id",                     null: false
    t.string   "owner_type",                   null: false
    t.integer  "platform_id",                  null: false
    t.string   "target_mode", default: "user", null: false
    t.integer  "status",      default: 0,      null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "general_notifications", ["owner_type", "owner_id"], name: "index_general_notifications_on_owner_type_and_owner_id", using: :btree
  add_index "general_notifications", ["platform_id"], name: "index_general_notifications_on_platform_id", using: :btree
  add_index "general_notifications", ["status"], name: "index_general_notifications_on_status", using: :btree

  create_table "group_subgroup_approvals", force: :cascade do |t|
    t.boolean  "active",      default: false, null: false
    t.integer  "group_id",                    null: false
    t.integer  "subgroup_id",                 null: false
    t.integer  "user_id",                     null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "group_subgroup_approvals", ["group_id", "subgroup_id"], name: "index_group_subgroup_uniq", unique: true, using: :btree
  add_index "group_subgroup_approvals", ["user_id", "group_id", "subgroup_id"], name: "index_group_subgroup_user", using: :btree

# Could not dump table "groups" because of following StandardError
#   Unknown type 'group_category' for column 'category'

  create_table "identification_type_translations", force: :cascade do |t|
    t.integer  "identification_type_id", null: false
    t.string   "locale",                 null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "name"
  end

  add_index "identification_type_translations", ["identification_type_id"], name: "index_3eced3b0d5c266262c924b61f67785bc2cd4a1f6", using: :btree
  add_index "identification_type_translations", ["locale"], name: "index_identification_type_translations_on_locale", using: :btree

  create_table "identification_types", force: :cascade do |t|
    t.boolean  "active",     default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "identification_types", ["active"], name: "index_identification_types_on_active", using: :btree

  create_table "identifications", force: :cascade do |t|
    t.integer  "user_id",                                  null: false
    t.string   "front_image_file_name"
    t.string   "front_image_content_type"
    t.integer  "front_image_file_size"
    t.datetime "front_image_updated_at"
    t.string   "back_image_file_name"
    t.string   "back_image_content_type"
    t.integer  "back_image_file_size"
    t.datetime "back_image_updated_at"
    t.integer  "identification_type_id",                   null: false
    t.boolean  "pending_verification",     default: true
    t.boolean  "verified",                 default: false
    t.datetime "verified_at"
    t.string   "verifier_type"
    t.string   "verifier_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "identification_number"
    t.boolean  "active",                   default: true,  null: false
  end

  add_index "identifications", ["active"], name: "index_identifications_on_active", using: :btree
  add_index "identifications", ["identification_number"], name: "index_identifications_on_identification_number", using: :btree
  add_index "identifications", ["identification_type_id"], name: "index_identifications_on_identification_type_id", using: :btree
  add_index "identifications", ["pending_verification"], name: "index_identifications_on_pending_verification", using: :btree
  add_index "identifications", ["user_id"], name: "index_identifications_on_user_id", using: :btree
  add_index "identifications", ["verified"], name: "index_identifications_on_verified", using: :btree
  add_index "identifications", ["verifier_id", "verifier_type"], name: "index_identifications_on_verifier_id_and_verifier_type", using: :btree

  create_table "image_attachments", force: :cascade do |t|
    t.integer  "message_attachment_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.text     "uploaded_url"
  end

  add_index "image_attachments", ["message_attachment_id"], name: "index_image_attachments_on_message_attachment_id", using: :btree

  create_table "liked_offers", force: :cascade do |t|
    t.integer  "special_offer_id", null: false
    t.integer  "user_id",          null: false
    t.integer  "group_id",         null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "liked_offers", ["user_id", "special_offer_id", "group_id"], name: "index_liked_offers_on_user_id_and_special_offer_id_and_group_id", unique: true, using: :btree

  create_table "location_attachments", force: :cascade do |t|
    t.integer  "message_attachment_id"
    t.float    "latitude",              null: false
    t.float    "longitude",             null: false
    t.text     "address"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "location_attachments", ["message_attachment_id"], name: "index_location_attachments_on_message_attachment_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "active",     default: false, null: false
  end

  add_index "memberships", ["group_id", "user_id"], name: "index_memberships_on_group_id_and_user_id", using: :btree
  add_index "memberships", ["user_id", "group_id"], name: "index_memberships_on_user_id_and_group_id", unique: true, using: :btree

  create_table "mentioned_attributes", force: :cascade do |t|
    t.string   "attribute_name", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "mentioned_attributes", ["attribute_name"], name: "index_mentioned_attributes_on_attribute_name", using: :btree

  create_table "mentioned_users", force: :cascade do |t|
    t.integer  "mentioned_user_id"
    t.integer  "owner_id",               null: false
    t.string   "owner_type",             null: false
    t.integer  "mentionable_id",         null: false
    t.string   "mentionable_type",       null: false
    t.integer  "start_index",            null: false
    t.integer  "end_index",              null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "mentioned_attribute_id", null: false
  end

  add_index "mentioned_users", ["mentionable_id", "mentionable_type"], name: "index_mentioned_users_on_mentionable_id_and_mentionable_type", using: :btree
  add_index "mentioned_users", ["mentioned_attribute_id"], name: "index_mentioned_users_on_mentioned_attribute_id", using: :btree
  add_index "mentioned_users", ["mentioned_user_id"], name: "index_mentioned_users_on_mentioned_user_id", using: :btree
  add_index "mentioned_users", ["owner_id", "owner_type"], name: "index_mentioned_users_on_owner_id_and_owner_type", using: :btree

  create_table "message_attachments", force: :cascade do |t|
    t.string   "attachment_type", null: false
    t.integer  "attachment_id",   null: false
    t.integer  "message_id",      null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "message_attachments", ["message_id"], name: "index_message_attachments_on_message_id", using: :btree

  create_table "message_sent_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id",           null: false
    t.integer  "conversation_message_id"
    t.string   "owner_type",                            null: false
    t.integer  "owner_id",                    limit: 8, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "message_sent_notifiers", ["owner_id", "owner_type"], name: "index_message_sent_notifiers_on_owner_id_and_owner_type", using: :btree
  add_index "message_sent_notifiers", ["owner_id"], name: "index_message_sent_notifiers_on_owner_id", using: :btree
  add_index "message_sent_notifiers", ["owner_type"], name: "index_message_sent_notifiers_on_owner_type", using: :btree
  add_index "message_sent_notifiers", ["showoff_sns_notification_id"], name: "index_message_sent_notifiers_on_notification", using: :btree

  create_table "messaged_objects", force: :cascade do |t|
    t.string   "recipient_type"
    t.integer  "recipient_id"
    t.integer  "message_id",     null: false
    t.integer  "status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "messaged_objects", ["message_id"], name: "index_messaged_objects_on_message_id", using: :btree
  add_index "messaged_objects", ["recipient_id"], name: "index_messaged_objects_on_recipient_id", using: :btree
  add_index "messaged_objects", ["recipient_type"], name: "index_messaged_objects_on_recipient_type", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "owner_type",                     null: false
    t.integer  "owner_id",                       null: false
    t.text     "text",                           null: false
    t.integer  "status",                         null: false
    t.integer  "conversation_id",                null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "activated",       default: true, null: false
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["status"], name: "index_messages_on_status", using: :btree

  create_table "notification_setting_user_notification_settings", force: :cascade do |t|
    t.integer  "user_notification_setting_id",                null: false
    t.integer  "notification_setting_id",                     null: false
    t.boolean  "enabled",                      default: true, null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "notification_setting_user_notification_settings", ["enabled"], name: "index_notification_settings_on_enabled", using: :btree
  add_index "notification_setting_user_notification_settings", ["notification_setting_id"], name: "index_notification_setting_on_notification_setting_id", using: :btree
  add_index "notification_setting_user_notification_settings", ["user_notification_setting_id"], name: "index_notification_setting_on_user_setting_id", using: :btree

  create_table "notification_settings", force: :cascade do |t|
    t.string   "name",        null: false
    t.text     "description", null: false
    t.string   "slug",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "offer_approvals", force: :cascade do |t|
    t.integer  "special_offer_id",                 null: false
    t.integer  "group_id",                         null: false
    t.integer  "user_id",                          null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "active",           default: false, null: false
  end

  add_index "offer_approvals", ["group_id", "special_offer_id"], name: "index_offer_approvals_on_group_id_and_special_offer_id", unique: true, using: :btree
  add_index "offer_approvals", ["user_id", "group_id", "special_offer_id"], name: "index_approved_offers_user_id_group_id_special_offer_id", using: :btree

  create_table "platform_translations", force: :cascade do |t|
    t.integer  "platform_id", null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
  end

  add_index "platform_translations", ["locale"], name: "index_platform_translations_on_locale", using: :btree
  add_index "platform_translations", ["platform_id"], name: "index_platform_translations_on_platform_id", using: :btree

  create_table "platforms", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "platforms", ["email"], name: "index_platforms_on_email", unique: true, using: :btree
  add_index "platforms", ["reset_password_token"], name: "index_platforms_on_reset_password_token", unique: true, using: :btree

  create_table "posts", force: :cascade do |t|
    t.citext   "title",                             null: false
    t.citext   "details",                           null: false
    t.integer  "postable_id"
    t.string   "postable_type"
    t.boolean  "active",             default: true, null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "posts", ["postable_type", "postable_id"], name: "index_posts_on_postable_type_and_postable_id", using: :btree
  add_index "posts", ["title"], name: "index_posts_on_title", unique: true, using: :btree

  create_table "reports", force: :cascade do |t|
    t.integer  "reporter_id",     limit: 8,                 null: false
    t.string   "reporter_type",                             null: false
    t.integer  "reportable_id",   limit: 8,                 null: false
    t.string   "reportable_type",                           null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "considered",                default: false, null: false
    t.integer  "reason",                    default: 0,     null: false
  end

  add_index "reports", ["considered"], name: "index_reports_on_considered", using: :btree
  add_index "reports", ["reason"], name: "index_reports_on_reason", using: :btree
  add_index "reports", ["reportable_id", "reportable_type"], name: "index_reports_on_reportable_id_and_reportable_type", using: :btree
  add_index "reports", ["reportable_type"], name: "index_reports_on_reportable_type", using: :btree
  add_index "reports", ["reporter_id", "reporter_type"], name: "index_reports_on_reporter_id_and_reporter_type", using: :btree
  add_index "reports", ["reporter_type"], name: "index_reports_on_reporter_type", using: :btree

  create_table "showoff_facebook_friend_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id"
    t.integer  "owner_id",                    limit: 8, null: false
    t.text     "owner_type",                            null: false
    t.text     "facebook_username",                     null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "showoff_facebook_friend_notifiers", ["owner_id"], name: "index_showoff_facebook_friend_notifiers_on_owner_id", using: :btree
  add_index "showoff_facebook_friend_notifiers", ["owner_type", "owner_id"], name: "index_showoff_facebook_friend_notifiers_on_owner", using: :btree
  add_index "showoff_facebook_friend_notifiers", ["owner_type"], name: "index_showoff_facebook_friend_notifiers_on_owner_type", using: :btree
  add_index "showoff_facebook_friend_notifiers", ["showoff_sns_notification_id"], name: "index_facebook_friend_notifier_on_notification", using: :btree

  create_table "showoff_payments_customer_identities", force: :cascade do |t|
    t.integer  "customer_id",         limit: 8,                null: false
    t.string   "customer_type",                                null: false
    t.integer  "vendor_identity_id"
    t.integer  "provider_id",                                  null: false
    t.boolean  "active",                        default: true, null: false
    t.text     "provider_identifier",                          null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "showoff_payments_customer_identities", ["active"], name: "showoff_payments_customer_identities_active", using: :btree
  add_index "showoff_payments_customer_identities", ["customer_id", "customer_type"], name: "showoff_payments_customer_identities_customer", using: :btree
  add_index "showoff_payments_customer_identities", ["customer_type"], name: "showoff_payments_customer_identities_customer_type", using: :btree
  add_index "showoff_payments_customer_identities", ["provider_id"], name: "showoff_payments_customer_identities_payment_provider", using: :btree
  add_index "showoff_payments_customer_identities", ["provider_identifier"], name: "showoff_payments_customer_identities_provider_identifier", using: :btree
  add_index "showoff_payments_customer_identities", ["vendor_identity_id"], name: "showoff_payments_customer_identities_vendor_identity", using: :btree

  create_table "showoff_payments_providers", force: :cascade do |t|
    t.integer  "name",       default: 0, null: false
    t.string   "slug",                   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "showoff_payments_providers", ["name"], name: "showoff_payment_providers_name", using: :btree
  add_index "showoff_payments_providers", ["slug"], name: "showoff_payment_providers_slug", using: :btree

  create_table "showoff_payments_receipts", force: :cascade do |t|
    t.integer  "status",                         default: 0, null: false
    t.integer  "customer_identity_id",                       null: false
    t.integer  "vendor_identity_id"
    t.integer  "source_id"
    t.integer  "purchase_id",          limit: 8,             null: false
    t.string   "purchase_type",                              null: false
    t.float    "amount",                                     null: false
    t.float    "application_fee",                            null: false
    t.integer  "credits",                        default: 0, null: false
    t.string   "currency",                                   null: false
    t.integer  "quantity",                       default: 1, null: false
    t.text     "notes"
    t.integer  "address_id"
    t.string   "address_type"
    t.text     "provider_identifier",                        null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "showoff_payments_receipts", ["address_id", "address_type"], name: "showoff_payments_receipts_address", using: :btree
  add_index "showoff_payments_receipts", ["address_id"], name: "index_showoff_payments_receipts_on_address_id", using: :btree
  add_index "showoff_payments_receipts", ["address_type"], name: "index_showoff_payments_receipts_on_address_type", using: :btree
  add_index "showoff_payments_receipts", ["credits"], name: "index_showoff_payments_receipts_on_credits", using: :btree
  add_index "showoff_payments_receipts", ["currency"], name: "index_showoff_payments_receipts_on_currency", using: :btree
  add_index "showoff_payments_receipts", ["customer_identity_id"], name: "index_showoff_payments_receipts_on_customer_identity_id", using: :btree
  add_index "showoff_payments_receipts", ["provider_identifier"], name: "index_showoff_payments_receipts_on_provider_identifier", using: :btree
  add_index "showoff_payments_receipts", ["purchase_id", "purchase_type"], name: "showoff_payments_receipts_purchase", using: :btree
  add_index "showoff_payments_receipts", ["purchase_type"], name: "index_showoff_payments_receipts_on_purchase_type", using: :btree
  add_index "showoff_payments_receipts", ["quantity"], name: "index_showoff_payments_receipts_on_quantity", using: :btree
  add_index "showoff_payments_receipts", ["source_id"], name: "index_showoff_payments_receipts_on_source_id", using: :btree
  add_index "showoff_payments_receipts", ["status"], name: "index_showoff_payments_receipts_on_status", using: :btree
  add_index "showoff_payments_receipts", ["vendor_identity_id"], name: "index_showoff_payments_receipts_on_vendor_identity_id", using: :btree

  create_table "showoff_payments_receipts_vouchers", force: :cascade do |t|
    t.integer "receipt_id"
    t.integer "voucher_id",   null: false
    t.string  "voucher_type", null: false
  end

  add_index "showoff_payments_receipts_vouchers", ["voucher_id", "voucher_type"], name: "showoff_payments_receipts_vouchers_voucher", using: :btree
  add_index "showoff_payments_receipts_vouchers", ["voucher_id"], name: "index_showoff_payments_receipts_vouchers_on_voucher_id", using: :btree
  add_index "showoff_payments_receipts_vouchers", ["voucher_type"], name: "index_showoff_payments_receipts_vouchers_on_voucher_type", using: :btree

  create_table "showoff_payments_refunds", force: :cascade do |t|
    t.integer  "receipt_id",                          null: false
    t.float    "amount",                              null: false
    t.boolean  "application_fee",     default: false, null: false
    t.text     "provider_identifier",                 null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "showoff_payments_refunds", ["provider_identifier"], name: "index_showoff_payments_refunds_on_provider_identifier", using: :btree
  add_index "showoff_payments_refunds", ["receipt_id"], name: "index_showoff_payments_refunds_on_receipt_id", using: :btree

  create_table "showoff_payments_sources", force: :cascade do |t|
    t.boolean  "active",               default: true,  null: false
    t.boolean  "default",              default: false, null: false
    t.integer  "customer_identity_id",                 null: false
    t.integer  "vendor_identity_id"
    t.string   "brand",                                null: false
    t.string   "country"
    t.string   "cvc_check"
    t.string   "last_four",                            null: false
    t.integer  "exp_month",                            null: false
    t.integer  "exp_year",                             null: false
    t.text     "provider_identifier",                  null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "showoff_payments_sources", ["active"], name: "showoff_payments_sources_active", using: :btree
  add_index "showoff_payments_sources", ["brand"], name: "index_showoff_payments_sources_on_brand", using: :btree
  add_index "showoff_payments_sources", ["country"], name: "index_showoff_payments_sources_on_country", using: :btree
  add_index "showoff_payments_sources", ["customer_identity_id"], name: "index_showoff_payments_sources_on_customer_identity_id", using: :btree
  add_index "showoff_payments_sources", ["cvc_check"], name: "index_showoff_payments_sources_on_cvc_check", using: :btree
  add_index "showoff_payments_sources", ["default"], name: "showoff_payments_sources_default", using: :btree
  add_index "showoff_payments_sources", ["exp_month"], name: "index_showoff_payments_sources_on_exp_month", using: :btree
  add_index "showoff_payments_sources", ["exp_year"], name: "index_showoff_payments_sources_on_exp_year", using: :btree
  add_index "showoff_payments_sources", ["last_four"], name: "index_showoff_payments_sources_on_last_four", using: :btree
  add_index "showoff_payments_sources", ["provider_identifier"], name: "index_showoff_payments_sources_on_provider_identifier", using: :btree
  add_index "showoff_payments_sources", ["vendor_identity_id"], name: "index_showoff_payments_sources_on_vendor_identity_id", using: :btree

  create_table "showoff_payments_vendor_identities", force: :cascade do |t|
    t.integer  "vendor_id",            limit: 8,                null: false
    t.string   "vendor_type",                                   null: false
    t.integer  "provider_id",                                   null: false
    t.boolean  "active",                         default: true, null: false
    t.text     "provider_identifier",                           null: false
    t.integer  "vendor_identity_type",           default: 0,    null: false
    t.text     "provider_secret"
    t.text     "provider_key"
    t.text     "text"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "showoff_payments_vendor_identities", ["active"], name: "showoff_payments_vendor_identities_active", using: :btree
  add_index "showoff_payments_vendor_identities", ["provider_id"], name: "showoff_payments_vendor_identities_payment_provider", using: :btree
  add_index "showoff_payments_vendor_identities", ["provider_identifier"], name: "showoff_payments_vendor_identities_provider_identifier", using: :btree
  add_index "showoff_payments_vendor_identities", ["provider_key"], name: "index_showoff_payments_vendor_identities_on_provider_key", using: :btree
  add_index "showoff_payments_vendor_identities", ["provider_secret"], name: "index_showoff_payments_vendor_identities_on_provider_secret", using: :btree
  add_index "showoff_payments_vendor_identities", ["text"], name: "index_showoff_payments_vendor_identities_on_text", using: :btree
  add_index "showoff_payments_vendor_identities", ["vendor_id", "vendor_type"], name: "showoff_payments_vendor_identities_vendor", using: :btree
  add_index "showoff_payments_vendor_identities", ["vendor_identity_type"], name: "showoff_payments_vendor_identities_vendor_identity_type", using: :btree

  create_table "showoff_payments_vendor_identity_meta_datas", force: :cascade do |t|
    t.integer  "vendor_identity_id",                                 null: false
    t.text     "country"
    t.text     "default_currency"
    t.text     "currencies_supported"
    t.integer  "identification_status",               default: 0,    null: false
    t.text     "identification_details"
    t.text     "identification_details_code"
    t.text     "identification_provider_identifier"
    t.text     "verification_fields_required"
    t.text     "verification_fields_disabled_reason"
    t.datetime "verification_fields_required_by"
    t.boolean  "payments_charges_enabled",            default: true, null: false
    t.boolean  "payments_transfers_enabled",          default: true, null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "showoff_payments_vendor_identity_meta_datas", ["country"], name: "showoff_payments_vendor_identity_meta_datas_country", using: :btree
  add_index "showoff_payments_vendor_identity_meta_datas", ["currencies_supported"], name: "showoff_payments_vendor_identity_meta_datas_currency_s", using: :btree
  add_index "showoff_payments_vendor_identity_meta_datas", ["default_currency"], name: "showoff_payments_vendor_identity_meta_datas_currency", using: :btree
  add_index "showoff_payments_vendor_identity_meta_datas", ["identification_details"], name: "showoff_payments_vendor_identity_meta_datas_id_d", using: :btree
  add_index "showoff_payments_vendor_identity_meta_datas", ["identification_details_code"], name: "showoff_payments_vendor_identity_meta_datas_id_d_c", using: :btree
  add_index "showoff_payments_vendor_identity_meta_datas", ["identification_provider_identifier"], name: "showoff_payments_vendor_identity_meta_datas_id_p_i", using: :btree
  add_index "showoff_payments_vendor_identity_meta_datas", ["identification_status"], name: "showoff_payments_vendor_identity_meta_datas_id_s", using: :btree
  add_index "showoff_payments_vendor_identity_meta_datas", ["payments_charges_enabled"], name: "showoff_payments_vendor_identity_meta_datas_charges_enabled", using: :btree
  add_index "showoff_payments_vendor_identity_meta_datas", ["payments_transfers_enabled"], name: "showoff_payments_vendor_identity_meta_datas_transfers_enabled", using: :btree
  add_index "showoff_payments_vendor_identity_meta_datas", ["vendor_identity_id"], name: "showoff_payments_vendor_identity_meta_datas_vendor_identity", using: :btree
  add_index "showoff_payments_vendor_identity_meta_datas", ["verification_fields_disabled_reason"], name: "showoff_payments_vendor_identity_meta_datas_v_f_d_r", using: :btree
  add_index "showoff_payments_vendor_identity_meta_datas", ["verification_fields_required"], name: "showoff_payments_vendor_identity_meta_datas_v_f_r", using: :btree
  add_index "showoff_payments_vendor_identity_meta_datas", ["verification_fields_required_by"], name: "showoff_payments_vendor_identity_meta_datas_v_f_r_by", using: :btree

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
    t.integer  "notifiable_id",                 limit: 8,             null: false
    t.string   "notifiable_type",                                     null: false
    t.integer  "owner_id",                      limit: 8,             null: false
    t.string   "owner_type",                                          null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "showoff_sns_notified_objects", ["notifiable_id", "notifiable_type"], name: "sns_notified_object_notifiable", using: :btree
  add_index "showoff_sns_notified_objects", ["notifiable_id"], name: "index_showoff_sns_notified_objects_on_notifiable_id", using: :btree
  add_index "showoff_sns_notified_objects", ["notifiable_type"], name: "index_showoff_sns_notified_objects_on_notifiable_type", using: :btree
  add_index "showoff_sns_notified_objects", ["owner_id", "owner_type", "notifiable_id", "notifiable_type"], name: "sns_notified_object_owner_notifiable", using: :btree
  add_index "showoff_sns_notified_objects", ["owner_id", "owner_type"], name: "sns_notified_object_owner", using: :btree
  add_index "showoff_sns_notified_objects", ["owner_id"], name: "index_showoff_sns_notified_objects_on_owner_id", using: :btree
  add_index "showoff_sns_notified_objects", ["owner_type"], name: "index_showoff_sns_notified_objects_on_owner_type", using: :btree
  add_index "showoff_sns_notified_objects", ["showoff_sns_notification_id"], name: "sns_notified_object_notification", using: :btree
  add_index "showoff_sns_notified_objects", ["showoff_sns_notified_class_id"], name: "sns_notified_object_notified_class", using: :btree
  add_index "showoff_sns_notified_objects", ["status"], name: "sns_notified_object_status", using: :btree

  create_table "special_offers", force: :cascade do |t|
    t.citext   "title",                             null: false
    t.citext   "details"
    t.datetime "publish_on"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "active",             default: true, null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "advertiser",         default: "",   null: false
    t.string   "location"
  end

  add_index "special_offers", ["title"], name: "index_special_offers_on_title", unique: true, using: :btree

  create_table "subgroup_events_approvals", force: :cascade do |t|
    t.boolean  "active",      default: false, null: false
    t.integer  "group_id",                    null: false
    t.integer  "subgroup_id",                 null: false
    t.integer  "user_id",                     null: false
    t.integer  "event_id",                    null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "subgroup_events_approvals", ["group_id", "subgroup_id", "event_id"], name: "index_group_subgroup_event_uniq", unique: true, using: :btree
  add_index "subgroup_events_approvals", ["user_id", "group_id", "subgroup_id", "event_id"], name: "index_group_subgroup_event_user", using: :btree

  create_table "tagged_attributes", force: :cascade do |t|
    t.string   "attribute_name", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "tagged_attributes", ["attribute_name"], name: "index_tagged_attributes_on_attribute_name", using: :btree

  create_table "tagged_objects", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id",         null: false
    t.string   "taggable_type",       null: false
    t.integer  "owner_id",            null: false
    t.string   "owner_type",          null: false
    t.integer  "start_index",         null: false
    t.integer  "end_index",           null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "tagged_attribute_id", null: false
  end

  add_index "tagged_objects", ["owner_id", "owner_type"], name: "index_tagged_objects_on_owner_id_and_owner_type", using: :btree
  add_index "tagged_objects", ["taggable_id", "taggable_type"], name: "index_tagged_objects_on_taggable_id_and_taggable_type", using: :btree
  add_index "tagged_objects", ["tagged_attribute_id"], name: "index_tagged_objects_on_tagged_attribute_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.text     "text",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tags", ["text"], name: "index_tags_on_text", using: :btree

  create_table "upcoming_event_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id",           null: false
    t.integer  "event_id",                              null: false
    t.string   "owner_type",                            null: false
    t.integer  "owner_id",                    limit: 8, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "upcoming_event_notifiers", ["event_id"], name: "index_upcoming_event_notifiers_on_event_id", using: :btree
  add_index "upcoming_event_notifiers", ["owner_id", "owner_type"], name: "index_upcoming_event_notifiers_on_owner_id_and_owner_type", using: :btree
  add_index "upcoming_event_notifiers", ["owner_id"], name: "index_upcoming_event_notifiers_on_owner_id", using: :btree
  add_index "upcoming_event_notifiers", ["owner_type"], name: "index_upcoming_event_notifiers_on_owner_type", using: :btree
  add_index "upcoming_event_notifiers", ["showoff_sns_notification_id"], name: "index_upcoming_event_notifiers_on_notification", using: :btree

  create_table "user_age_range_translations", force: :cascade do |t|
    t.integer  "user_age_range_id", null: false
    t.string   "locale",            null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "name"
  end

  add_index "user_age_range_translations", ["locale"], name: "index_user_age_range_translations_on_locale", using: :btree
  add_index "user_age_range_translations", ["user_age_range_id"], name: "index_user_age_range_translations_on_user_age_range_id", using: :btree

  create_table "user_age_ranges", force: :cascade do |t|
    t.integer  "start_age",                 null: false
    t.integer  "end_age",                   null: false
    t.boolean  "active",     default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "user_age_ranges", ["active"], name: "index_user_age_ranges_on_active", using: :btree

  create_table "user_businesses", force: :cascade do |t|
    t.integer  "user_id",      null: false
    t.string   "name",         null: false
    t.string   "tax_id"
    t.string   "country_code"
    t.string   "line1"
    t.string   "line2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "user_businesses", ["country_code"], name: "index_user_businesses_on_country_code", using: :btree
  add_index "user_businesses", ["user_id"], name: "index_user_businesses_on_user_id", using: :btree

  create_table "user_facebook_event_import_notifiers", force: :cascade do |t|
    t.integer  "showoff_sns_notification_id",             null: false
    t.integer  "user_facebook_event_import_id",           null: false
    t.string   "owner_type",                              null: false
    t.integer  "owner_id",                      limit: 8, null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "user_facebook_event_import_notifiers", ["owner_id", "owner_type"], name: "index_user_facebook_event_import_notifiers_on_owner", using: :btree
  add_index "user_facebook_event_import_notifiers", ["owner_id"], name: "index_user_facebook_event_import_notifiers_on_owner_id", using: :btree
  add_index "user_facebook_event_import_notifiers", ["owner_type"], name: "index_user_facebook_event_import_notifiers_on_owner_type", using: :btree
  add_index "user_facebook_event_import_notifiers", ["showoff_sns_notification_id"], name: "index_user_facebook_event_import_notifiers_on_notification", using: :btree
  add_index "user_facebook_event_import_notifiers", ["user_facebook_event_import_id"], name: "index_user_facebook_event_on_user_facebook_event_impor", using: :btree

  create_table "user_facebook_event_imports", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.text     "access_token",               null: false
    t.integer  "status",         default: 0, null: false
    t.integer  "imported_count", default: 0, null: false
    t.integer  "failed_count",   default: 0, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "user_facebook_event_imports", ["failed_count"], name: "index_user_facebook_event_imports_on_failed_count", using: :btree
  add_index "user_facebook_event_imports", ["imported_count"], name: "index_user_facebook_event_imports_on_imported_count", using: :btree
  add_index "user_facebook_event_imports", ["status"], name: "index_user_facebook_event_imports_on_status", using: :btree
  add_index "user_facebook_event_imports", ["user_id"], name: "index_user_facebook_event_imports_on_user_id", using: :btree

  create_table "user_feed_items", force: :cascade do |t|
    t.integer  "feed_item_id", null: false
    t.integer  "user_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "user_feed_items", ["feed_item_id"], name: "index_user_feed_items_on_feed_item_id", using: :btree
  add_index "user_feed_items", ["user_id"], name: "index_user_feed_items_on_user_id", using: :btree

  create_table "user_logins", force: :cascade do |t|
    t.integer  "user_id",         null: false
    t.string   "ip"
    t.text     "user_agent"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "request"
    t.text     "isp"
    t.integer  "application_id"
    t.integer  "access_token_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "user_logins", ["access_token_id"], name: "index_user_logins_on_access_token_id", using: :btree
  add_index "user_logins", ["application_id"], name: "index_user_logins_on_application_id", using: :btree
  add_index "user_logins", ["latitude"], name: "index_user_logins_on_latitude", using: :btree
  add_index "user_logins", ["longitude"], name: "index_user_logins_on_longitude", using: :btree
  add_index "user_logins", ["user_id"], name: "index_user_logins_on_user_id", using: :btree

  create_table "user_notification_settings", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_notification_settings", ["user_id"], name: "index_user_notification_settings_on_user_id", using: :btree

  create_table "user_tags", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "tag_id",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_tags", ["tag_id"], name: "index_user_tags_on_tag_id", using: :btree
  add_index "user_tags", ["user_id"], name: "index_user_tags_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                    default: "",    null: false
    t.string   "encrypted_password",       default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.datetime "date_of_birth"
    t.string   "facebook_uid"
    t.string   "facebook_access_token"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "location"
    t.string   "description"
    t.string   "school"
    t.string   "work"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "gender"
    t.boolean  "notifications_enabled",    default: true,  null: false
    t.string   "country_code"
    t.string   "tos_acceptance_ip"
    t.datetime "tos_acceptance_timestamp"
    t.integer  "account_type"
    t.boolean  "has_bank_account",         default: false, null: false
    t.boolean  "has_payment_method",       default: false, null: false
    t.boolean  "active",                   default: true,  null: false
    t.integer  "user_type",                default: 0,     null: false
    t.string   "business_name"
    t.boolean  "suspended",                default: false, null: false
    t.datetime "inactive_at"
    t.datetime "suspended_at"
    t.string   "cover_image_file_name"
    t.string   "cover_image_content_type"
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.integer  "friend_count",             default: 0,     null: false
    t.boolean  "eighteen_plus",            default: false
    t.boolean  "save_events_to_calendar",  default: false, null: false
    t.integer  "user_age_range_id"
    t.string   "user_name"
    t.string   "facebook_profile_link"
    t.string   "linkedin_profile_link"
    t.string   "instagram_profile_link"
    t.string   "snapchat_profile_link"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["eighteen_plus"], name: "index_users_on_eighteen_plus", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["inactive_at"], name: "index_users_on_inactive_at", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["suspended", "active"], name: "index_users_on_suspended_and_active", using: :btree
  add_index "users", ["suspended"], name: "index_users_on_suspended", using: :btree
  add_index "users", ["suspended_at"], name: "index_users_on_suspended_at", using: :btree
  add_index "users", ["user_age_range_id"], name: "index_users_on_user_age_range_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  create_table "video_attachments", force: :cascade do |t|
    t.integer  "message_attachment_id"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.text     "uploaded_url"
  end

  add_index "video_attachments", ["message_attachment_id"], name: "index_video_attachments_on_message_attachment_id", using: :btree

  add_foreign_key "addresses", "users"
  add_foreign_key "conversation_participants", "conversations"
  add_foreign_key "conversations", "events"
  add_foreign_key "event_attendee_contributions", "event_attendees"
  add_foreign_key "event_attendee_request_owner_notifiers", "event_attendee_requests"
  add_foreign_key "event_attendee_request_owner_notifiers", "showoff_sns_notifications"
  add_foreign_key "event_attendee_request_response_notifiers", "event_attendee_requests"
  add_foreign_key "event_attendee_request_response_notifiers", "showoff_sns_notifications"
  add_foreign_key "event_attendee_requests", "event_attendees"
  add_foreign_key "event_attendees", "events"
  add_foreign_key "event_attendees", "users"
  add_foreign_key "event_cancelled_notifiers", "showoff_sns_notifications"
  add_foreign_key "event_contribution_details", "event_contribution_types"
  add_foreign_key "event_contribution_details", "events"
  add_foreign_key "event_invitation_notifiers", "event_attendees"
  add_foreign_key "event_invitation_notifiers", "showoff_sns_notifications"
  add_foreign_key "event_media_items", "events"
  add_foreign_key "event_owner_attendee_notifiers", "event_attendees"
  add_foreign_key "event_owner_attendee_notifiers", "showoff_sns_notifications"
  add_foreign_key "event_share_notifiers", "event_shares"
  add_foreign_key "event_share_notifiers", "showoff_sns_notifications"
  add_foreign_key "event_share_users", "event_shares"
  add_foreign_key "event_share_users", "users"
  add_foreign_key "event_shares", "events"
  add_foreign_key "event_shares", "users"
  add_foreign_key "event_ticket_detail_views", "event_ticket_details"
  add_foreign_key "event_ticket_detail_views", "users"
  add_foreign_key "event_ticket_details", "events"
  add_foreign_key "event_timeline_item_comment_notifiers", "event_timeline_item_comments"
  add_foreign_key "event_timeline_item_comment_notifiers", "showoff_sns_notifications"
  add_foreign_key "event_timeline_item_comments", "event_timeline_items"
  add_foreign_key "event_timeline_item_comments", "users"
  add_foreign_key "event_timeline_item_like_notifiers", "event_timeline_item_likes"
  add_foreign_key "event_timeline_item_like_notifiers", "showoff_sns_notifications"
  add_foreign_key "event_timeline_item_likes", "event_timeline_items"
  add_foreign_key "event_timeline_item_likes", "users"
  add_foreign_key "event_timeline_item_media_items", "event_timeline_items"
  add_foreign_key "event_timeline_items", "events"
  add_foreign_key "event_timeline_items", "users"
  add_foreign_key "feed_item_contexts", "feed_item_actions"
  add_foreign_key "feed_items", "feed_item_contexts"
  add_foreign_key "friend_request_notifiers", "friend_requests"
  add_foreign_key "friend_request_notifiers", "showoff_sns_notifications"
  add_foreign_key "friend_requests", "users"
  add_foreign_key "friendship_notifiers", "friendships"
  add_foreign_key "friendship_notifiers", "showoff_sns_notifications"
  add_foreign_key "friendships", "users"
  add_foreign_key "general_notification_notifiers", "general_notifications"
  add_foreign_key "general_notification_notifiers", "showoff_sns_notifications"
  add_foreign_key "general_notification_users", "general_notifications"
  add_foreign_key "general_notification_users", "users"
  add_foreign_key "general_notifications", "platforms"
  add_foreign_key "groups", "users", name: "groups_user_id_fk", on_delete: :cascade
  add_foreign_key "identifications", "identification_types"
  add_foreign_key "identifications", "users"
  add_foreign_key "image_attachments", "message_attachments"
  add_foreign_key "liked_offers", "groups", name: "liked_offers_group_id_fk", on_delete: :cascade
  add_foreign_key "liked_offers", "special_offers", name: "liked_offers_special_offer_fk", on_delete: :cascade
  add_foreign_key "liked_offers", "users", name: "liked_offers_user_id_fk", on_delete: :cascade
  add_foreign_key "location_attachments", "message_attachments"
  add_foreign_key "memberships", "groups", name: "memberships_group_id_fk", on_delete: :cascade
  add_foreign_key "memberships", "users", name: "memberships_user_id_fk", on_delete: :cascade
  add_foreign_key "mentioned_users", "users", column: "mentioned_user_id"
  add_foreign_key "message_attachments", "messages"
  add_foreign_key "message_sent_notifiers", "showoff_sns_notifications"
  add_foreign_key "messaged_objects", "messages"
  add_foreign_key "messages", "conversations"
  add_foreign_key "notification_setting_user_notification_settings", "notification_settings"
  add_foreign_key "notification_setting_user_notification_settings", "user_notification_settings"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "offer_approvals", "groups", name: "approved_offers_group_id_fk", on_delete: :cascade
  add_foreign_key "offer_approvals", "special_offers", name: "approved_offers_special_offer_fk", on_delete: :cascade
  add_foreign_key "offer_approvals", "users", name: "approved_offers_user_id_fk", on_delete: :cascade
  add_foreign_key "showoff_facebook_friend_notifiers", "showoff_sns_notifications"
  add_foreign_key "showoff_sns_notified_objects", "showoff_sns_notifications"
  add_foreign_key "upcoming_event_notifiers", "showoff_sns_notifications"
  add_foreign_key "user_businesses", "users"
  add_foreign_key "user_facebook_event_import_notifiers", "showoff_sns_notifications"
  add_foreign_key "user_facebook_event_import_notifiers", "user_facebook_event_imports"
  add_foreign_key "user_facebook_event_imports", "users"
  add_foreign_key "user_feed_items", "feed_items"
  add_foreign_key "user_feed_items", "users"
  add_foreign_key "user_logins", "users"
  add_foreign_key "user_notification_settings", "users"
  add_foreign_key "user_tags", "tags"
  add_foreign_key "user_tags", "users"
  add_foreign_key "users", "user_age_ranges"
  add_foreign_key "video_attachments", "message_attachments"
end
