# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
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
                            department_id: 2)
subject_2 = Subject.create!(name: 'Física II A', code: '03', credits: 6, department_id: 4)
subject_3 = Subject.create!(name: 'Taller de desarrollo de proyectos informáticos II', code: '48',
                            credits: 6, department_id: 1)
subject_4 = Subject.create!(name: 'Estructura del computador', code: '70', credits: 6,
                            department_id: 3)

school_term = SchoolTerm.create!(term: 1, year: '2018', date_start: '2018-08-18',
                                 date_end: '2018-12-01')
past_school_term = SchoolTerm.create!(term: 0, year: '2018', date_start: '2018-03-18',
                                      date_end: '2018-07-01')

course_1 = Course.create!(name: '001', vacancies: 2, subject: subject_1, school_term: school_term)
course_2 = Course.create!(name: '002', vacancies: 2, subject: subject_2, school_term: school_term)
course_3 = Course.create!(name: '003', vacancies: 2, subject: subject_3, school_term: school_term)
course_4 = Course.create!(name: '004', vacancies: 2, subject: subject_4, school_term: school_term)
course_5 = Course.create!(name: '005', vacancies: 2, subject: subject_3, school_term: school_term)
course_6 = Course.create!(name: '006', vacancies: 2, subject: subject_3,
                          school_term: past_school_term)

LessonSchedule.create!(course: course_3, classroom: classroom_1, type: :theory, day: :Monday,
                       hour_start: '17:00', hour_end: '19:00')
LessonSchedule.create!(course: course_3, classroom: classroom_2, type: :practice, day: :Monday,
                       hour_start: '19:00', hour_end: '23:00')

teacher_1 = Teacher.create!(email: 'teacher1@example.com', password: '12345678',
                            first_name: 'Carlos', last_name: 'Fontela',
                            personal_document_number: '30000000', birthdate: '1970-01-01',
                            phone_number: '44444444', address: 'Some address 123')

teacher_2 = Teacher.create!(email: 'teacher2@example.com', password: '12345678',
                            first_name: 'Luis', last_name: 'Argerich',
                            personal_document_number: '30000001', birthdate: '1970-01-01',
                            phone_number: '44444445', address: 'Some address 1234')

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

TeacherCourse.create!(course_id: 3, teacher_id: 1, teaching_position: :course_chief)
TeacherCourse.create!(course_id: 2, teacher_id: 1, teaching_position: :course_chief)
TeacherCourse.create!(course_id: 3, teacher_id: 2, teaching_position: :practice_chief)
