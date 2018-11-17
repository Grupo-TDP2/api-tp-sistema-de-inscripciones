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

  private

  def process_row(row)
    teacher = Teacher.new(row.to_hash)
    if row.to_hash.values.last.nil?
      @proccesed_errors += "- Linea #{@line}: Número de columnas erroneo\n"
      @failed += 1
    else
      import_model(teacher)
    end
    @line += 1
  end
end
