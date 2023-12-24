class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end
  # returns result based off valid and if it's complete
  # atgriež rezultātu skatoties uz to vai ir pabeigts un ir patiess.
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

  # Check if the puzzle is valid by validating columns, row and subgroup
  #pārbauda vai uzdevums ir derīgs, pārbaudot kolonas, rindas un apakšgrupas
  def valid?
    rows = valid_rows?
    columns = valid_columns?
    subgroups = valid_subgroups?

    rows && columns && subgroups
  end
  

  # Check if the puzzle is incomplete
  # Pārbauda vai sudoku ir pabeigts
  def incomplete?
    @puzzle_string.include?('0')
  end

# Check if all rows are valid
# Pārbauda vai visas rindas ir derīgas/patiesas
def valid_rows?
  result = @puzzle_string.each_line.with_index.all? do |row, index| #This part iterates through each line of the @puzzle_string and checks if the given block returns true for all rows.
    row_values = row.scan(/\d+/).map(&:to_i)  # Iziet cauri katram numuram un pārbauda vai atrgriež patiess vai nepatiess ('true' vai 'false' )
    
    # Exclude zeros when checking for duplicates
    # Neskaita 0 kad meklē skaitļus kas atkārtojas
    non_zero_values = row_values.reject { |value| value.zero? }
    
    invalid_numbers = non_zero_values.select { |value| value < 1 || value > 9 }

    duplicates = non_zero_values.size > 1 && non_zero_values.size != non_zero_values.uniq.size
    contains_all_numbers = (1..9).all? { |num| row_values.count(num) <= 1 }

    (!duplicates || non_zero_values.empty?) && invalid_numbers.empty? && contains_all_numbers
  end
  result
end

# Check if all columns are valid
# Pārbauda vai vissas kolonas ir derīgas/patiesas
def valid_columns?
  result = (0...9).all? do |col|
    column = @puzzle_string.each_line.map { |row| row.scan(/\d+/)[col].to_i } # Basically the same as valid_rows?, except the way we look for numbers is diferent
    non_zero_values = column.reject { |value| value.zero? } # Gandrīz tas pats kas ar 'valid_rows?' izņemot veids kā meklē ciparus 

    invalid_numbers = non_zero_values.select { |value| value < 1 || value > 9 }

    duplicates = non_zero_values.size != non_zero_values.uniq.size
    contains_all_numbers = (1..9).all? { |num| column.count(num) <= 1 }

    (!duplicates || non_zero_values.empty?) && invalid_numbers.empty? && contains_all_numbers
  end
  result
end

# Check if all subgroups are valid
# Pārbauda vai vissas apakšgrupas ir derīgas/patiesas
def valid_subgroups?
  subgroups = [] # Initializes an empty array to store the 3x3 subgroups / izveido tukšu masīvu, lai saglabātu 3x3 apakšgrupas

  # Divide the puzzle into 3x3 subgroups / sadala 3x3 apakšgrupās
  (0..2).each do |row_offset| #These loops iterate over possible row and column offsets for the 3x3 subgroups 
    (0..2).each do |col_offset| 
      subgroup = []
      (0..2).each do |i| #These nested loops iterate over each cell within a 3x3 subgroup.
        (0..2).each do |j|
          actual_row = row_offset * 3 + i # Calculates the actual row index in the puzzle by considering both the row offset and the current loop index 'i' / Aprēķina rindas indeksu apakšgrupā, ņemot vērā gan rindas nobīdi, gan pašreizējās cikla indeksu 'i'.
          row = actual_row + (actual_row / 3) # Computes the row index within the subgroup. This ensures that when moving from one subgroup to the next, the row index increases by one (to avoid errors) / Aprēķina rindas indeksu apakšgrupā. Tas nodrošina, ka, pārejot no vienas apakšgrupas uz nākamo, rindas indekss palielinās par vienu(lai izvairītos no kļūdas)
          col = col_offset * 3 + j
          value = @puzzle_string.each_line.map { |line| line.scan(/\d/)[col].to_i }[row]
          subgroup << value unless value.zero?
        end
      end
      subgroups << subgroup
    end
  end

  result = subgroups.all? do |subgroup|
    non_zero_values = subgroup.reject { |value| value.zero? }

    invalid_numbers = non_zero_values.select { |value| value < 1 || value > 9 }

    duplicates = non_zero_values.size != non_zero_values.uniq.size
    contains_all_numbers = (1..9).all? { |num| subgroup.count(num) <= 1 }

    (!duplicates || non_zero_values.empty?) && invalid_numbers.empty? && contains_all_numbers
  end

  result
end
end