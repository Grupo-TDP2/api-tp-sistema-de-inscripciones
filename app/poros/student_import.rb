class StudentImport
  def initialize(params)
    @file = params[:file]
    @import_file = ImportFile.new(model: params[:model].downcase, filename: params[:filename])
  end

  def process
    # process csv file
    @import_file.update(rows_successfuly_processed: 0, rows_unsuccessfuly_processed: 0)
    @import_file
  end
end
