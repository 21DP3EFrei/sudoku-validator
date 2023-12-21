class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

 def validate
 return valid or invalid

 private 

 def valid
  begin
  (valid_rows && valid_columns) = true
 raise "Sudoku is valid"
 puts a.to_s
rescue Exception => a
else if valid_rows @puzzle_string contains 0
  check valid_group where  
  puts 'Sudoku is valid but incomplete'
 end
 end
 end
 
 def invalid
  (valid_rows && valid_columns) = false
 end

 def valid_rows
  @puzzle_string.each_line.all do |row|
    valid_group(row)
  end
end


 def valid_columns
(1...9).all? do |col|
  column = @puzzle_string.each_line.map { |row| row[col] }
  valid_group?(column.join)
end
end

def valid_group(group)
  group.chars.all? {|ch| ch.between?('1', '9')} && group.chars.uniq.size = group.size
end
def valid_subgrids?
  subgrid_size = Math.sqrt(@puzzle.size).to_i
  (0...@puzzle.size).step(subgrid_size).all? do |start_row|
    (0...@puzzle.size).step(subgrid_size).all? do |start_col|
      subgrid = @puzzle[start_row, subgrid_size].map { |row| row[start_col, subgrid_size] }.flatten
      !contains_duplicates?(subgrid)
    end
  end
end