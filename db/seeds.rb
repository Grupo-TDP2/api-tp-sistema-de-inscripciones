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
