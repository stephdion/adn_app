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

ActiveRecord::Schema.define(version: 20150219145331) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blessure_mechanisms", force: :cascade do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "blessure_operations", force: :cascade do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "blessure_surfaces", force: :cascade do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "blessures", force: :cascade do |t|
    t.integer  "user_id",                                                  null: false
    t.string   "partie_du_corp",        limit: 255
    t.string   "cote_du_corp",          limit: 255
    t.string   "type_de_blessure",      limit: 255
    t.string   "mechanism",             limit: 255
    t.string   "surface",               limit: 255
    t.boolean  "retour_au_jeu"
    t.string   "symptomes_data",        limit: 255
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.date     "date",                              default: '2013-09-27', null: false
    t.integer  "equipe_type_id"
    t.string   "operation",             limit: 255
    t.string   "detail",                limit: 255
    t.date     "operation_date"
    t.integer  "original_report_id"
    t.integer  "reporter_id"
    t.integer  "body_part_id"
    t.integer  "body_side_id"
    t.integer  "blessure_type_id"
    t.integer  "blessure_operation_id"
    t.integer  "blessure_surface_id"
    t.integer  "blessure_mechanism_id"
    t.integer  "equipe_id"
  end

  create_table "blessuretypes", force: :cascade do |t|
    t.string   "name_fr",     limit: 255
    t.string   "code",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "blessuretypes", ["code"], name: "index_blessuretypes_on_code", unique: true, using: :btree

  create_table "bodyparts", force: :cascade do |t|
    t.string   "name_fr",     limit: 255
    t.string   "code",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.boolean  "has_side"
  end

  add_index "bodyparts", ["code"], name: "index_bodyparts_on_code", unique: true, using: :btree

  create_table "bodysides", force: :cascade do |t|
    t.string   "name_fr",     limit: 255
    t.string   "code",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "bodysides", ["code"], name: "index_bodysides_on_code", unique: true, using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "nom",          limit: 255
    t.string   "organization", limit: 255
    t.string   "prenom",       limit: 255
    t.string   "user_type",    limit: 255
    t.string   "email",        limit: 255
    t.string   "telephone",    limit: 255
    t.string   "other",        limit: 255
    t.boolean  "archive"
    t.boolean  "receive_news"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "equipe_types", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "organization_id"
  end

  create_table "equipes", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "description",     limit: 255
    t.integer  "equipe_type_id"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "organization_id"
  end

  create_table "eval_tests", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "image_file_name",     limit: 255
    t.string   "image_content_type",  limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "video",               limit: 255
    t.string   "short_name",          limit: 255
    t.boolean  "component"
    t.boolean  "left_right"
    t.integer  "test_subcategory_id"
    t.integer  "organization_id"
  end

  add_index "eval_tests", ["user_id", "created_at"], name: "index_eval_tests_on_user_id_and_created_at", using: :btree

  create_table "eval_types", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "organization_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "evaluations", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "point_desc0",     limit: 255
    t.string   "point_desc1",     limit: 255
    t.string   "point_desc2",     limit: 255
    t.string   "point_desc3",     limit: 255
    t.integer  "eval_type_id"
    t.integer  "organization_id"
    t.string   "point_presc0",    limit: 255
    t.string   "point_presc1",    limit: 255
    t.string   "point_presc2",    limit: 255
    t.string   "point_presc3",    limit: 255
  end

  create_table "exercise_categories", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "organization_id"
  end

  create_table "exercise_sets", force: :cascade do |t|
    t.integer  "exercise_id"
    t.integer  "programme_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.date     "archived"
  end

  create_table "exercise_subcategories", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.integer  "exercise_category_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "organization_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.text     "description"
    t.integer  "user_id"
    t.string   "video",                   limit: 255
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "image_file_name",         limit: 255
    t.string   "image_content_type",      limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "short_desc",              limit: 255
    t.string   "short_name",              limit: 255
    t.integer  "exercise_subcategory_id"
    t.integer  "organization_id"
  end

  add_index "exercises", ["user_id"], name: "index_exercises_on_user_id", using: :btree

  create_table "family_members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "parent_id"
    t.string   "relationship", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "mail_users", force: :cascade do |t|
    t.integer  "uid_from"
    t.integer  "uid_to"
    t.text     "message"
    t.string   "subject",      limit: 255
    t.integer  "deleted",                  default: 0
    t.integer  "read",                     default: 0
    t.datetime "date_created"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "organization_id"
    t.integer  "role_id"
    t.date     "archived"
    t.date     "year_since_join"
  end

  create_table "newsletters", force: :cascade do |t|
    t.string "email", limit: 255
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "code",        limit: 255
    t.boolean  "isSystem",                default: false
  end

  create_table "participations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "equipe_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "position_id"
    t.date     "archived"
  end

  add_index "participations", ["user_id", "equipe_id"], name: "index_participations_on_user_id_and_equipe_id", using: :btree

  create_table "positions", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "equipe_type_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "organization_id"
  end

  create_table "prescriptions", force: :cascade do |t|
    t.integer  "eval_test_id"
    t.integer  "exercise_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "exercise_order"
    t.date     "archived"
  end

  create_table "programmes", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "resultats", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "equipe_id"
    t.integer  "athlete_id"
    t.integer  "evaluation_id"
    t.integer  "eval_test_id"
    t.integer  "value"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "contacted"
    t.integer  "component"
    t.integer  "left_side"
  end

  add_index "resultats", ["eval_test_id"], name: "index_resultats_on_eval_test_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "code",        limit: 255
    t.boolean  "isSystem",                default: false
  end

  add_index "roles", ["code"], name: "index_roles_on_code", unique: true, using: :btree

  create_table "scat2_cognitions", force: :cascade do |t|
    t.string   "code",       limit: 255, null: false
    t.integer  "value",                  null: false
    t.integer  "scat2_id",               null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "scat2_concentrations", force: :cascade do |t|
    t.string   "code",       limit: 255, null: false
    t.integer  "value",                  null: false
    t.integer  "scat2_id",               null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "scat2_memories", force: :cascade do |t|
    t.string   "code",       limit: 255, null: false
    t.integer  "value",                  null: false
    t.integer  "scat2_id",               null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "scat2_symptoms", force: :cascade do |t|
    t.string   "code",       limit: 255, null: false
    t.integer  "value",                  null: false
    t.integer  "scat2_id",               null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "scat2s", force: :cascade do |t|
    t.integer  "user_id",                                 null: false
    t.integer  "equipe_type_id",                          null: false
    t.datetime "incident_datetime",                       null: false
    t.datetime "evaluation_datetime",                     null: false
    t.integer  "owner_id",                                null: false
    t.integer  "symptoms_physical"
    t.integer  "symptoms_mental"
    t.string   "behaviour_change",            limit: 255
    t.integer  "unconsciousness"
    t.integer  "unconsciousness_time"
    t.integer  "balance_problem"
    t.integer  "glasgow_eye"
    t.integer  "glasgow_verbal"
    t.integer  "glasgow_mouvement"
    t.integer  "maddocks_state"
    t.integer  "maddocks_half_time"
    t.integer  "maddocks_last_goal"
    t.integer  "maddocks_last_team"
    t.integer  "maddocks_last_win"
    t.integer  "cognitive_month"
    t.integer  "cognitive_date"
    t.integer  "cognitive_day"
    t.integer  "cognitive_year"
    t.integer  "cognitive_hrs"
    t.integer  "concentration_inverse_month"
    t.integer  "stability_two_feet"
    t.integer  "stability_one_foot"
    t.integer  "stability_feet_aligned"
    t.integer  "coordination"
    t.integer  "cognition_differed_memory"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "foot_tested",                 limit: 255
    t.string   "hand_tested",                 limit: 255
    t.integer  "symptoms_worst_physical"
    t.integer  "symptoms_worst_mental"
    t.string   "global_estimation",           limit: 255
    t.string   "return_to_competition",       limit: 255
  end

  create_table "symptomes", force: :cascade do |t|
    t.string   "code"
    t.string   "string"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "symptomes_blessures", force: :cascade do |t|
    t.integer  "symptome_id"
    t.integer  "blessure_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "test_categories", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "organization_id"
  end

  create_table "test_sets", force: :cascade do |t|
    t.integer  "eval_test_id"
    t.integer  "evaluation_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "test_order"
    t.integer  "exercise_order"
    t.date     "archived"
  end

  create_table "test_subcategories", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.integer  "test_category_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "organization_id"
  end

  create_table "user_anthropometrics", force: :cascade do |t|
    t.integer  "height"
    t.integer  "weight"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "archive"
    t.date     "archiveDate"
  end

  create_table "user_emails", force: :cascade do |t|
    t.string   "email_type", limit: 255, null: false
    t.string   "email",      limit: 255, null: false
    t.integer  "user_id",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "user_phones", force: :cascade do |t|
    t.string   "phone_type", limit: 255, null: false
    t.string   "number",     limit: 255, null: false
    t.integer  "user_id",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "last_name",                limit: 255,                 null: false
    t.string   "email",                    limit: 255
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "password_digest",          limit: 255
    t.string   "remember_token",           limit: 255
    t.string   "registration_token",       limit: 255
    t.boolean  "is_enabled",                                           null: false
    t.string   "first_name",               limit: 255,                 null: false
    t.string   "address",                  limit: 255
    t.string   "city",                     limit: 255
    t.string   "state",                    limit: 255
    t.string   "postalCode",               limit: 255
    t.string   "country",                  limit: 255
    t.date     "birthday"
    t.string   "sex",                      limit: 255
    t.boolean  "change_password_required",             default: false, null: false
    t.string   "photo_file_name",          limit: 255
    t.string   "photo_content_type",       limit: 255
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "banner_content_type",      limit: 255
    t.integer  "banner_file_size"
    t.string   "banner_file_name",         limit: 255
    t.datetime "banner_updated_at"
    t.integer  "user_phones_count",                    default: 0,     null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "vouchers", force: :cascade do |t|
    t.string   "token",           limit: 255
    t.text     "description"
    t.integer  "role_id"
    t.integer  "organization_id"
    t.boolean  "is_enabled",                  default: true
    t.boolean  "isSystem",                    default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "vouchers", ["token"], name: "index_vouchers_on_token", unique: true, using: :btree

  add_foreign_key "blessures", "blessure_mechanisms", name: "blessure_blessure_mechanisms_fk"
  add_foreign_key "blessures", "blessure_operations", name: "blessure_blessure_operations_fk"
  add_foreign_key "blessures", "blessure_surfaces", name: "blessure_blessure_surfaces_fk"
  add_foreign_key "blessures", "blessuretypes", column: "blessure_type_id", name: "blessures_blessuretypes_fk"
  add_foreign_key "blessures", "bodyparts", column: "body_part_id", name: "blessures_body_part_fk"
  add_foreign_key "blessures", "bodysides", column: "body_side_id", name: "blessures_body_side_fk"
  add_foreign_key "blessures", "equipe_types", name: "blessures_equipe_type_id_fk"
  add_foreign_key "blessures", "equipes"
  add_foreign_key "blessures", "users", column: "reporter_id", name: "blessures_reporter_id_fk"
  add_foreign_key "blessures", "users", name: "blessures_user_id_fk"
  add_foreign_key "equipe_types", "organizations", name: "equipe_types_organization_id_fk"
  add_foreign_key "equipes", "equipe_types", name: "equipes_equipe_type_id_fk"
  add_foreign_key "equipes", "organizations", name: "equipes_organization_id_fk"
  add_foreign_key "equipes", "users", name: "equipes_user_id_fk"
  add_foreign_key "eval_tests", "organizations", name: "eval_tests_organization_id_fk"
  add_foreign_key "eval_tests", "test_subcategories", name: "eval_tests_test_subcategory_id_fk"
  add_foreign_key "eval_tests", "users", name: "eval_tests_user_id_fk"
  add_foreign_key "eval_types", "organizations", name: "eval_types_organization_id_fk"
  add_foreign_key "evaluations", "eval_types", name: "evaluations_eval_type_id_fk"
  add_foreign_key "evaluations", "organizations", name: "evaluations_organization_id_fk"
  add_foreign_key "evaluations", "users", name: "evaluations_user_id_fk"
  add_foreign_key "exercise_categories", "organizations", name: "exercise_categories_organization_id_fk"
  add_foreign_key "exercise_sets", "exercises", name: "exercise_sets_exercise_id_fk"
  add_foreign_key "exercise_sets", "programmes", name: "exercise_sets_programme_id_fk"
  add_foreign_key "exercise_subcategories", "exercise_categories", name: "exercise_subcategories_exercise_category_id_fk"
  add_foreign_key "exercise_subcategories", "organizations", name: "exercise_subcategories_organization_id_fk"
  add_foreign_key "exercises", "exercise_subcategories", name: "exercises_exercise_subcategory_id_fk"
  add_foreign_key "exercises", "organizations", name: "exercises_organization_id_fk"
  add_foreign_key "exercises", "users", name: "exercises_user_id_fk"
  add_foreign_key "family_members", "users", column: "parent_id", name: "family_members_parent_id_fk"
  add_foreign_key "family_members", "users", name: "family_members_user_id_fk"
  add_foreign_key "memberships", "organizations", name: "memberships_organization_id_fk"
  add_foreign_key "memberships", "roles", name: "memberships_role_id_fk"
  add_foreign_key "memberships", "users", name: "memberships_user_id_fk"
  add_foreign_key "participations", "equipes", name: "participations_equipe_id_fk"
  add_foreign_key "participations", "positions", name: "participations_position_id_fk"
  add_foreign_key "participations", "users", name: "participations_user_id_fk"
  add_foreign_key "positions", "equipe_types", name: "positions_equipe_type_id_fk"
  add_foreign_key "positions", "organizations", name: "positions_organization_id_fk"
  add_foreign_key "prescriptions", "eval_tests", name: "prescriptions_eval_test_id_fk"
  add_foreign_key "prescriptions", "exercises", name: "prescriptions_exercise_id_fk"
  add_foreign_key "programmes", "users", name: "programmes_user_id_fk"
  add_foreign_key "resultats", "equipes", name: "resultats_equipe_id_fk"
  add_foreign_key "resultats", "eval_tests", name: "resultats_eval_test_id_fk"
  add_foreign_key "resultats", "evaluations", name: "resultats_evaluation_id_fk"
  add_foreign_key "resultats", "users", column: "athlete_id", name: "resultats_athlete_id_fk"
  add_foreign_key "resultats", "users", name: "resultats_user_id_fk"
  add_foreign_key "scat2_cognitions", "scat2s", name: "scat2_cognitions_scat2_id_fk"
  add_foreign_key "scat2_concentrations", "scat2s", name: "scat2_concentrations_scat2_id_fk"
  add_foreign_key "scat2_memories", "scat2s", name: "scat2_memories_scat2_id_fk"
  add_foreign_key "scat2_symptoms", "scat2s", name: "scat2_symptoms_scat2_id_fk"
  add_foreign_key "scat2s", "equipe_types", name: "scat2s_equipe_type_id_fk"
  add_foreign_key "scat2s", "users", column: "owner_id", name: "scat2s_owner_id_fk"
  add_foreign_key "scat2s", "users", name: "scat2s_user_id_fk"
  add_foreign_key "symptomes_blessures", "blessures", name: "symptomesblessures_blessures_fk"
  add_foreign_key "symptomes_blessures", "symptomes", name: "symptomesblessures_symptomes_fk"
  add_foreign_key "test_categories", "organizations", name: "test_categories_organization_id_fk"
  add_foreign_key "test_sets", "eval_tests", name: "test_sets_eval_test_id_fk"
  add_foreign_key "test_sets", "evaluations", name: "test_sets_evaluation_id_fk"
  add_foreign_key "test_subcategories", "organizations", name: "test_subcategories_organization_id_fk"
  add_foreign_key "test_subcategories", "test_categories", name: "test_subcategories_test_category_id_fk"
  add_foreign_key "user_anthropometrics", "users", name: "user_anthropometrics_user_id_fk"
  add_foreign_key "user_emails", "users", name: "user_emails_user_id_fk"
  add_foreign_key "user_phones", "users", name: "user_phones_user_id_fk"
  add_foreign_key "vouchers", "organizations", name: "organizations_voucher_id_fk"
  add_foreign_key "vouchers", "organizations", name: "vouchers_organization_id_fk"
  add_foreign_key "vouchers", "roles", name: "roles_voucher_id_fk"
  add_foreign_key "vouchers", "roles", name: "vouchers_role_id_fk"
end
