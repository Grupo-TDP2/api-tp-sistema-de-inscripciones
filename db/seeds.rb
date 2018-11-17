# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
CourseOfStudy.delete_all
DepartmentStaff.delete_all
LessonSchedule.delete_all
Course.delete_all
Subject.delete_all
Department.delete_all
Classroom.delete_all
Building.delete_all
SchoolTerm.delete_all
Teacher.delete_all
Student.delete_all
TeacherCourse.delete_all
Enrolment.delete_all
FinalExamWeek.delete_all
Exam.delete_all
Admin.delete_all

course_of_study_1 = CourseOfStudy.create!(name: 'Ingeniería en Informática', required_credits: 240)
course_of_study_2 = CourseOfStudy.create!(name: 'Ingeniería Química', required_credits: 240)
course_of_study_3 = CourseOfStudy.create!(name: 'Ingeniería Electrónica', required_credits: 240)
course_of_study_4 = CourseOfStudy.create!(name: 'Ingeniería Mecánica', required_credits: 240)

building_1 = Building.create!(name: 'PC', address: 'Av. Paseo Colón 850', postal_code: '1063',
                              city: 'CABA')
building_2 = Building.create!(name: 'LH', address: 'Av. Gral. Las Heras 2220', postal_code: '1126',
                              city: 'CABA')

classroom_1 = Classroom.create!(floor: '3', number: '22', building: building_1)
classroom_2 = Classroom.create!(floor: '3', number: '03', building: building_1)
classroom_3 = Classroom.create!(floor: '3', number: '02', building: building_1)
classroom_4 = Classroom.create!(floor: '1', number: '06', building: building_2)

department_1 = Department.create!(name: 'Departamento de Informática', code: '75')
department_2 = Department.create!(name: 'Departamento de Matemática', code: '61')
department_3 = Department.create!(name: 'Departamento de Electrónica', code: '66')
department_4 = Department.create!(name: 'Departamento de Física', code: '62')

subject_1 = Subject.create!(name: 'Análisis matemático II A', code: '03', credits: 6,
                            department: department_2)
subject_2 = Subject.create!(name: 'Física II A', code: '03', credits: 6, department: department_4)
subject_3 = Subject.create!(name: 'Taller de desarrollo de proyectos informáticos II', code: '48',
                            credits: 6, department: department_1)
subject_4 = Subject.create!(name: 'Estructura del computador', code: '70', credits: 6,
                            department: department_3)

school_term = SchoolTerm.create!(term: :second_semester, year: '2018',
                                 date_start: Date.new(2018, 8, 10).next_week,
                                 date_end: Date.new(2018, 8, 10).next_week + 16.weeks)
past_school_term = SchoolTerm.create!(term: :first_semester, year: '2018',
                                      date_start: Date.new(2018, 3, 10).next_week,
                                      date_end: Date.new(2018, 3, 10).next_week + 16.weeks)
SchoolTerm.create!(term: :summer_school, year: '2018',
                   date_start: Date.new(2018, 1, 1).next_week,
                   date_end: Date.new(2018, 1, 1).next_week + 8.weeks)
prev_year_2_term = SchoolTerm.create!(term: :second_semester, year: '2017',
                                      date_start: Date.new(2017, 8, 1).next_week,
                                      date_end: Date.new(2017, 8, 1).next_week + 16.weeks)
prev_year_1_term = SchoolTerm.create!(term: :first_semester, year: '2017',
                                      date_start: Date.new(2017, 3, 10).next_week,
                                      date_end: Date.new(2017, 3, 10).next_week + 16.weeks)

week_1 = FinalExamWeek.create!(date_start_week: Date.new(2018, 12, 10), year: '2018')
week_2 = FinalExamWeek.create!(date_start_week: Date.new(2018, 12, 17), year: '2018')
week_3 = FinalExamWeek.create!(date_start_week: Date.new(2019, 2, 4), year: '2019')
week_4 = FinalExamWeek.create!(date_start_week: Date.new(2019, 2, 11), year: '2019')
week_5 = FinalExamWeek.create!(date_start_week: Date.new(2019, 2, 18), year: '2019')
week_6 = FinalExamWeek.create!(date_start_week: Date.new(2019, 2, 25), year: '2019')

course_1 = Course.create!(name: '001', vacancies: 2, subject: subject_1, school_term: school_term)
course_2 = Course.create!(name: '002', vacancies: 2, subject: subject_2, school_term: school_term)
course_3 = Course.create!(name: '003', vacancies: 0, subject: subject_3, school_term: school_term,
                          accept_free_condition_exam: true)
course_4 = Course.create!(name: '004', vacancies: 2, subject: subject_4, school_term: school_term)
course_5 = Course.create!(name: '005', vacancies: 2, subject: subject_3, school_term: school_term)
course_6 = Course.create!(name: '006', vacancies: 2, subject: subject_1,
                          school_term: past_school_term)
course_7 = Course.create!(name: '007', vacancies: 0, subject: subject_3,
                          school_term: past_school_term, accept_free_condition_exam: true)
course_8 = Course.create!(name: '008', vacancies: 0, subject: subject_3,
                          school_term: prev_year_2_term, accept_free_condition_exam: true)
course_9 = Course.create!(name: '009', vacancies: 0, subject: subject_3,
                          school_term: prev_year_1_term, accept_free_condition_exam: true)

Exam.create!(course: course_3, final_exam_week: week_1,
             date_time: Time.zone.parse('2018-12-12 17:00:00'), classroom: classroom_1)
Exam.new(course: course_3, final_exam_week: week_1, date_time: 3.days.from_now,
         classroom: classroom_1).save(validate: false)

LessonSchedule.create!(course: course_3, classroom: classroom_1, type: :theory, day: :monday,
                       hour_start: '17:00', hour_end: '19:00')
LessonSchedule.create!(course: course_3, classroom: classroom_2, type: :practice, day: :monday,
                       hour_start: '19:00', hour_end: '23:00')
LessonSchedule.create!(course: course_1, classroom: classroom_3, type: :theory, day: :tuesday,
                      hour_start: '17:00', hour_end: '19:00')
LessonSchedule.create!(course: course_1, classroom: classroom_4, type: :practice, day: :wednesday,
                      hour_start: '19:00', hour_end: '23:00')
LessonSchedule.create!(course: course_2, classroom: classroom_1, type: :theory, day: :thursday,
                       hour_start: '17:00', hour_end: '19:00')
LessonSchedule.create!(course: course_2, classroom: classroom_2, type: :practice, day: :thursday,
                       hour_start: '19:00', hour_end: '23:00')
LessonSchedule.create!(course: course_4, classroom: classroom_3, type: :theory, day: :friday,
                      hour_start: '17:00', hour_end: '19:00')
LessonSchedule.create!(course: course_4, classroom: classroom_4, type: :practice, day: :friday,
                      hour_start: '19:00', hour_end: '23:00')
LessonSchedule.create!(course: course_5, classroom: classroom_1, type: :theory, day: :saturday,
                       hour_start: '7:00', hour_end: '10:00')
LessonSchedule.create!(course: course_5, classroom: classroom_2, type: :practice, day: :saturday,
                       hour_start: '10:00', hour_end: '13:00')
LessonSchedule.create!(course: course_6, classroom: classroom_3, type: :theory, day: :monday,
                      hour_start: '17:00', hour_end: '19:00')
LessonSchedule.create!(course: course_6, classroom: classroom_4, type: :practice, day: :tuesday,
                      hour_start: '19:00', hour_end: '23:00')


teacher_1 = Teacher.create!(email: 'teacher1@example.com', password: '12345678',
                            first_name: 'Carlos', last_name: 'Fontela',
                            username: 'teacher1@example.com', school_document_number: '1234567')

teacher_2 = Teacher.create!(email: 'teacher2@example.com', password: '12345678',
                            first_name: 'Luis', last_name: 'Argerich',
                            username: 'teacher2@example.com', school_document_number: '1234568')

student_1 = Student.create!(email: 'leandro.masello@example.com', password: '12345678',
                            first_name: 'Leandro', last_name: 'Masello',
                            school_document_number: '93106', username: 'leandro.masello',
                            priority: 1)

student_2 = Student.create!(email: 'juan.costamagna@example.com', password: '12345678',
                            first_name: 'Juan', last_name: 'Costamagna',
                            school_document_number: '93107', username: 'juan.costamagna',
                            priority: 1)

student_3 = Student.create!(email: 'enzo.perez@example.com', password: '12345678',
                            first_name: 'Enzo', last_name: 'Perez',
                            school_document_number: '93108', username: 'enzo.perez',
                            priority: 2)

DepartmentStaff.create!(email: 'staff_informatica@example.com', password: '12345678',
                        department: department_1)
Admin.create!(email: 'admin@example.com', password: '12345678')

course_of_study_1.subjects << subject_1
course_of_study_1.subjects << subject_2
course_of_study_1.subjects << subject_3
course_of_study_1.subjects << subject_4

course_of_study_2.subjects << subject_1
course_of_study_2.subjects << subject_2

course_of_study_3.subjects << subject_1
course_of_study_3.subjects << subject_2
course_of_study_3.subjects << subject_4

course_of_study_4.subjects << subject_1
course_of_study_4.subjects << subject_2

TeacherCourse.create!(course: course_2, teacher: teacher_1, teaching_position: :course_chief)
TeacherCourse.create!(course: course_3, teacher: teacher_2, teaching_position: :practice_chief)

# Enrolment.new(course: course_3, student: student_1, type: :normal).save(validate: false)
Enrolment.new(course: course_3, student: student_2, type: :normal, status: :approved,
              partial_qualification: 8).save(validate: false)
Enrolment.new(course: course_2, student: student_1, type: :normal).save(validate: false)
Enrolment.new(course: course_6, student: student_1, type: :normal, final_qualification: 6)
         .save(validate: false)
Enrolment.new(course: course_1, student: student_3, type: :normal, status: :approved,
              partial_qualification: 6).save(validate: false)
Enrolment.new(course: course_2, student: student_3, type: :normal, status: :approved,
              partial_qualification: 6, final_qualification: 6).save(validate: false)
Enrolment.new(course: course_8, student: student_3, type: :normal, status: :approved,
              partial_qualification: 6).save(validate: false)
Enrolment.new(course: course_9, student: student_3, type: :normal, status: :approved,
              partial_qualification: 6).save(validate: false)

StudentExam.new(exam: Exam.first, student: student_1, condition: :free).save(validate: false)
StudentExam.new(exam: Exam.first, student: student_2).save(validate: false)
StudentExam.new(exam: Exam.first, student: student_3).save(validate: false)
StudentExam.new(exam: Exam.last, student: student_1).save(validate: false)
