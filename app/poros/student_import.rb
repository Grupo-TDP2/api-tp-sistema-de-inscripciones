class StudentImport
  def initialize(params)
    @file = params[:file]
    @import_file = ImportFile.new(model: params[:model].downcase, filename: params[:filename])
  end

  def process
    CSV.parse(params[:file], :col_sep => ';') do |row|
      #byebug
      create(:student, row)
      p row
    end
    @import_file.update(rows_successfuly_processed: 0, rows_unsuccessfuly_processed: 0)
    @import_file
  end
end
