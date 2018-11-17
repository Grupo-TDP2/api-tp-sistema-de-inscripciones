class TeacherImport < Importer
  # Refactor from the last version. There is still much to improve
  def initialize(params)
    @file = params[:file]
    @import_file = ImportFile.new(model: params[:model].downcase, filename: params[:filename])
    @convert = { 'nombre' => 'first_name', 'apellido' => 'last_name', 'mail' => 'email',
                 'clave' => 'password', 'legajo' => 'school_document_number',
                 'usuario' => 'username' }
    @exp_headers = %w[first_name last_name email password school_document_number username]
    @success = 0
    @failed = 0
    @line = 0
    @proccesed_errors = ''
  end

  def process
    csv = read_csv
    raise ArgumentError unless all_headers? && right_number_of_headers?
    csv.to_a.map { |row| process_row(row) }
    @import_file.update(rows_successfuly_processed: @success, proccesed_errors: @proccesed_errors,
                        rows_unsuccessfuly_processed: @failed)
    @import_file
  end

  private

  def process_row(row)
    teacher = Teacher.new(row.to_hash)
    if row.to_hash.values.last.nil?
      @proccesed_errors += "- Linea #{@line}: Número de columnas erroneo\n"
      @failed += 1
    else
      import_teacher(teacher)
    end
    @line += 1
  end

  def import_teacher(teacher)
    if teacher.save
      @success += 1
    else
      @proccesed_errors += "- Linea #{@line}: #{teacher.errors.full_messages}\n"
      @failed += 1
    end
  end
end
