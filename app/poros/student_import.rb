class StudentImport < Importer
  # Refactor from the last version. There is still much to improve
  def initialize(params)
    @file = params[:file]
    @import_file = ImportFile.new(model: params[:model].downcase, filename: params[:filename])
    @success = 0
    @failed = 0
    @line = 0
    @proccesed_errors = ''
    @convert = { 'nombre' => 'first_name', 'apellido' => 'last_name', 'mail' => 'email',
                 'clave' => 'password', 'padrón' => 'school_document_number',
                 'usuario' => 'username', 'prioridad' => 'priority' }
    @exp_headers = %w[first_name last_name email password school_document_number username priority]
  end

  private

  def process_row(row)
    student = Student.new(row.to_hash)
    if wrong_columns?(row)
      @proccesed_errors += "- Linea #{@line}: Número de columnas erroneo\n"
      @failed += 1
    else
      import_model(student)
    end
    @line += 1
  end
end
