class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    result =
      if valid?
        'Sudoku is valid.'
      elsif incomplete?
        'Sudoku is valid but incomplete.'
      else
        'Sudoku is invalid.'
      end
    puts result
    result
  end

  private

  # Check if the puzzle is valid by validating rows and columns
  def valid?
    rows = valid_rows?
    columns = valid_columns?
  
    puts "Rows: #{rows}"
    puts "Columns: #{columns}"
  
    rows && columns
  end

  # Check if the puzzle is incomplete
  def incomplete?
    @puzzle_string.include?('0') && valid_rows? && valid_columns?
  end

  # Check if all rows are valid
  def valid_rows?
    result = @puzzle_string.each_line.all? { |row| !contains_duplicates?(row.scan(/\d+/).map(&:to_i)) }
    result
  end  

  # Check if all columns are valid
  def valid_columns?
    result = (0...9).all? do |col|
      column = @puzzle_string.each_line.map { |row| row.scan(/\d+/)[col].to_i }
      duplicates = contains_duplicates?(column)
      puts "Column #{col}: #{duplicates ? 'Invalid' : 'Valid'} #{column}"
      !duplicates
    end
    result
  end  

  # Check if an array contains duplicates
  def contains_duplicates?(array)
    array.compact.uniq.size != array.compact.size
  end
end