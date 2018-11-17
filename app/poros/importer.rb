class Importer
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
end
