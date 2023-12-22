class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    result =
      if valid? && incomplete?
        'Sudoku is valid but incomplete.'
      elsif valid?
        'Sudoku is valid.'
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
    @puzzle_string.include?('0')
  end

  # Check if all rows are valid
  def valid_rows?
    result = @puzzle_string.each_line.with_index.all? do |row, index|
      row_values = row.scan(/\d+/).map(&:to_i)

      # Exclude 0 when checking for duplicates
      non_zero_values = row_values.reject { |value| value.zero? }
      duplicates = non_zero_values.size > 1 && non_zero_values.size != non_zero_values.uniq.size

      # Check if each number from 1 to 9 is present at most once in the row
      contains_all_numbers = (1..9).all? { |num| row_values.count(num) <= 1 }

      puts "Row #{index}: Non-zero values: #{non_zero_values}, Duplicates: #{duplicates ? 'Invalid' : 'Valid'}, Contains all numbers: #{contains_all_numbers} #{row_values}"

      (!duplicates || non_zero_values.empty?) && contains_all_numbers && !contains_invalid_numbers?(row_values)
    end
    result
  end

  # Check if all columns are valid
  def valid_columns?
    result = (0...9).all? do |col|
      column = @puzzle_string.each_line.map { |row| row.scan(/\d+/)[col].to_i }
      # Exclude 0 when checking for duplicates
      non_zero_values = column.reject { |value| value.zero? }
      duplicates = non_zero_values.size > 1 && non_zero_values.size != non_zero_values.uniq.size

      # Check if each number from 1 to 9 is present at most once in the column
      contains_all_numbers = (1..9).all? { |num| column.count(num) <= 1 }

      puts "Column #{col}: Non-zero values: #{non_zero_values}, Duplicates: #{duplicates ? 'Invalid' : 'Valid'}, Contains all numbers: #{contains_all_numbers} #{column}"

      (!duplicates || non_zero_values.empty?) && contains_all_numbers
    end
    result
  end

  # Check if an array contains invalid numbers
  def contains_invalid_numbers?(array)
    array.any? { |value| value < 1 || value > 9 }
  end
end
