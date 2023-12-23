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
    subgroups = valid_subgroups?
  
    puts "Rows: #{rows}"
    puts "Columns: #{columns}"
    puts "Subgroups: #{subgroups}"
  
    rows && columns && subgroups
  end
  

  # Check if the puzzle is incomplete
  def incomplete?
    @puzzle_string.include?('0')
  end

# Check if all rows are valid
def valid_rows?
  result = @puzzle_string.each_line.with_index.all? do |row, index|
    row_values = row.scan(/\d+/).map(&:to_i)
    
    # Exclude zeros when checking for duplicates
    non_zero_values = row_values.reject { |value| value.zero? }
    
    invalid_numbers = non_zero_values.select { |value| value < 1 || value > 9 }

    duplicates = non_zero_values.size > 1 && non_zero_values.size != non_zero_values.uniq.size
    contains_all_numbers = (1..9).all? { |num| row_values.count(num) <= 1 }

    puts "Row #{index}: Non-zero values: #{non_zero_values}, Invalid Numbers: #{invalid_numbers}, Duplicates: #{duplicates ? 'Invalid' : 'Valid'}, Contains all numbers: #{contains_all_numbers} #{row_values}"

    (!duplicates || non_zero_values.empty?) && invalid_numbers.empty? && contains_all_numbers
  end
  result
end

# Check if all columns are valid
def valid_columns?
  result = (0...9).all? do |col|
    column = @puzzle_string.each_line.map { |row| row.scan(/\d+/)[col].to_i }
    non_zero_values = column.reject { |value| value.zero? }

    invalid_numbers = non_zero_values.select { |value| value < 1 || value > 9 }

    duplicates = non_zero_values.size != non_zero_values.uniq.size
    contains_all_numbers = (1..9).all? { |num| column.count(num) <= 1 }

    puts "Column #{col}: Non-zero values: #{non_zero_values}, Invalid Numbers: #{invalid_numbers}, Duplicates: #{duplicates ? 'Invalid' : 'Valid'}, Contains all numbers: #{contains_all_numbers} #{column}"

    (!duplicates || non_zero_values.empty?) && invalid_numbers.empty? && contains_all_numbers
  end
  result
end

# Check if all subgroups are valid
def valid_subgroups?
  result = (0..6).step(3).all? do |row|
    (0..6).step(3).all? do |col|
      subgroup = []
      (0..2).each do |i|
        (0..2).each do |j|
          # Adjust indices based on the current row and column
          cell_value = @puzzle_string[(row + i) * 9 + (col + j)].to_i
          subgroup << cell_value unless cell_value.zero?
        end
      end

      non_zero_values = subgroup.uniq
      duplicates = non_zero_values.size != subgroup.size

      puts "Subgroup: Non-zero values: #{non_zero_values}, Duplicates: #{duplicates ? 'Invalid' : 'Valid'}, Subgroup: #{subgroup}"

      !duplicates
    end
  end

  result
end
end