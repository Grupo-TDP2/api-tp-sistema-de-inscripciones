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

ActiveRecord::Schema.define(version: 20181019154301) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "buildings", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.string "postal_code", null: false
    t.string "city", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classrooms", force: :cascade do |t|
    t.string "floor", null: false
    t.string "number", null: false
    t.bigint "building_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_classrooms_on_building_id"
  end

  create_table "correlativities", force: :cascade do |t|
    t.bigint "subject_id"
    t.bigint "correlative_subject_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["correlative_subject_id"], name: "index_correlativities_on_correlative_subject_id"
    t.index ["subject_id", "correlative_subject_id"], name: "index_cor_subjects_on_subject_id_and_cor_subject_id", unique: true
    t.index ["subject_id"], name: "index_correlativities_on_subject_id"
  end

  create_table "course_of_studies", force: :cascade do |t|
    t.string "name", null: false
    t.integer "required_credits", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_of_study_subjects", force: :cascade do |t|
    t.bigint "subject_id"
    t.bigint "course_of_study_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_of_study_id"], name: "index_course_of_study_subjects_on_course_of_study_id"
    t.index ["subject_id"], name: "index_course_of_study_subjects_on_subject_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name", null: false
    t.integer "vacancies", null: false
    t.bigint "subject_id"
    t.bigint "school_term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accept_free_condition_exam", default: false, null: false
    t.index ["school_term_id"], name: "index_courses_on_school_term_id"
    t.index ["subject_id"], name: "index_courses_on_subject_id"
  end

  create_table "department_staffs", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_department_staffs_on_department_id"
    t.index ["email"], name: "index_department_staffs_on_email", unique: true
    t.index ["reset_password_token"], name: "index_department_staffs_on_reset_password_token", unique: true
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enrolments", force: :cascade do |t|
    t.integer "type", default: 0, null: false
    t.bigint "student_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.integer "final_qualification"
    t.integer "partial_qualification"
    t.index ["course_id"], name: "index_enrolments_on_course_id"
    t.index ["student_id"], name: "index_enrolments_on_student_id"
  end

  create_table "exams", force: :cascade do |t|
    t.integer "exam_type", default: 0, null: false
    t.bigint "final_exam_week_id", null: false
    t.bigint "course_id", null: false
    t.bigint "classroom_id", null: false
    t.datetime "date_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_exams_on_classroom_id"
    t.index ["course_id"], name: "index_exams_on_course_id"
    t.index ["final_exam_week_id"], name: "index_exams_on_final_exam_week_id"
  end

  create_table "final_exam_weeks", force: :cascade do |t|
    t.date "date_start_week", null: false
    t.string "year", default: "2018", null: false
  end

  create_table "import_files", force: :cascade do |t|
    t.string "filename", null: false
    t.integer "model", null: false
    t.integer "rows_successfuly_processed", null: false
    t.integer "rows_unsuccessfuly_processed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lesson_schedules", force: :cascade do |t|
    t.integer "type", null: false
    t.integer "day", null: false
    t.time "hour_start", null: false
    t.time "hour_end", null: false
    t.bigint "course_id"
    t.bigint "classroom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_lesson_schedules_on_classroom_id"
    t.index ["course_id"], name: "index_lesson_schedules_on_course_id"
  end

  create_table "school_terms", force: :cascade do |t|
    t.integer "term", null: false
    t.integer "year", null: false
    t.date "date_start", null: false
    t.date "date_end", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_exams", force: :cascade do |t|
    t.bigint "exam_id", null: false
    t.bigint "student_id", null: false
    t.integer "qualification"
    t.integer "condition", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_student_exams_on_exam_id"
    t.index ["student_id"], name: "index_student_exams_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "school_document_number", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.integer "priority", null: false
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.integer "credits", null: false
    t.bigint "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_subjects_on_department_id"
  end

  create_table "teacher_courses", force: :cascade do |t|
    t.integer "teaching_position", null: false
    t.bigint "teacher_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_teacher_courses_on_course_id"
    t.index ["teacher_id"], name: "index_teacher_courses_on_teacher_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "personal_document_number", null: false
    t.date "birthdate", null: false
    t.string "phone_number", null: false
    t.string "address", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_teachers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_teachers_on_reset_password_token", unique: true
  end

  add_foreign_key "classrooms", "buildings"
  add_foreign_key "courses", "school_terms"
  add_foreign_key "courses", "subjects"
  add_foreign_key "department_staffs", "departments"
  add_foreign_key "lesson_schedules", "classrooms"
  add_foreign_key "lesson_schedules", "courses"
  add_foreign_key "subjects", "departments"
end
