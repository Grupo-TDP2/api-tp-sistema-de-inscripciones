class Importer
  def process
    csv = read_csv
    raise ArgumentError unless all_headers? && right_number_of_headers?
    csv.to_a.map { |row| process_row(row) }
    @import_file.update(rows_successfuly_processed: @success, proccesed_errors: @proccesed_errors,
                        rows_unsuccessfuly_processed: @failed)
    @import_file
  end

  private

  def read_csv
    CSV.new(@file, headers: true,
                   header_converters: ->(header) { @convert[header.downcase.strip] },
                   converters: ->(field) { field ? field.strip : nil })
  end

  def file_headers
    csv_headers = CSV.new(@file, headers: true,
                                 header_converters: lambda { |header|
                                                      @convert[header.downcase.strip]
                                                    }).read
    csv_headers.headers
  end

  def all_headers?
    @exp_headers.all? { |header| file_headers.include?(header) }
  end

  def right_number_of_headers?
    @exp_headers.size == file_headers.size
  end

  def wrong_columns?(row)
    row.to_hash.values.last.nil?
  end

  def import_model(model)
    if model.save
      @success += 1
    else
      @proccesed_errors += "- Linea #{@line}: #{model.errors.full_messages}\n"
      @failed += 1
    end
  end
end
