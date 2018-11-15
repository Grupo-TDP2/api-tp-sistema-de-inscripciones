class StudentImport
  def initialize(params)
    @file = params[:file]
    @import_file = ImportFile.new(model: params[:model].downcase, filename: params[:filename])
  end

  def process
    # rubocop:disable Metrics/MethodLength Metrics/AbcSize Lint/Void
    convert = { 'nombre' => 'first_name', 'apellido' => 'last_name', 'mail' => 'email',
                'clave' => 'password', 'padrón' => 'school_document_number',
                'usuario' => 'username', 'prioridad' => 'priority' }
    expected_headers = %w[first_name last_name email
                          password school_document_number username priority]
    success = 0
    failed = 0
    line = 0
    proccesed_errors = ''
    csv = CSV.new(@file, headers: true,
                         header_converters: ->(header) { convert[header.downcase.strip] },
                         converters: ->(field) { field ? field.strip : nil })
    csv_headers = CSV.new(@file, headers: true,
                                 header_converters: lambda { |header|
                                                      convert[header.downcase.strip]
                                                    }).read

    file_headers = csv_headers.headers
    raise ArgumentError unless expected_headers.all? do |header|
                                 file_headers.include?(header)
                               end && expected_headers.size == file_headers.size

    csv.to_a.map do |row|
      student = Student.new(row.to_hash)
      if row.to_hash.values.last.nil?
        proccesed_errors += '- Linea ' + line.to_s + ': Número de columnas erroneo\n'
        failed += 1
      elsif student.save
        success += 1
      else
        proccesed_errors += '- Linea ' + line.to_s + ': '
        + student.errors.full_messages.to_s + '\n'
        failed += 1
      end
      line += 1
    end
    @import_file.update(rows_successfuly_processed: success, rows_unsuccessfuly_processed: failed,
                        proccesed_errors: proccesed_errors)
    @import_file
  end
end
