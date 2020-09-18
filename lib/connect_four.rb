require 'colorize'

CIRCLE = "\u2B24"

class Board
  attr_accessor :grid, :players

  def initialize
    @grid = Array.new(6) {Array.new(7)}
    @players = ["blue", "red"]
  end

  # check if tie, board is full
  def tie?
    # checks if board is full and no win
    @grid.flatten.none?{|space| space.nil?}
  end

  # add piece to board, piece goes in the last empty row (col empty too)
  def place_piece(col_num)
    # if the col num is valid (the col has an empty spot)
    if valid_column(col_num)
      # put a piece in the bottom of the col and return true
      @grid[get_last_empty_row(col_num)][col_num] = get_current_player_color
      return true
    # if the col num is not valid (invalid input)
    else
      false
    end
  end

  # column not full
  def valid_column(col_num)
    raise InvalidColumnNumberError if col_num.class != Integer

    if col_num.between?(0,6)

      # get all the column values for this column number
      col_values = []
      @grid.each do |row|
        col_values << row[col_num]
      end

      # reject the values that aren't empty
      col_values.select!{|val| val.nil?}

      !col_values.empty?
    else
      raise InvalidColumnNumberError
    end
  end

  # returns a row number
  def get_last_empty_row(col_num)
    # each row reverse
    @grid.reverse.each_with_index do |row, idx|
      return (5 - idx) if row[col_num].nil?
    end
  end

  # check win
  def win?
    # check all 3 win conditions
    check_rows || check_columns || check_diagonals
  end

  # check 4 row
  def check_rows
    @grid.each do |row|
      return true if Board.row_to_s(row).include?("bbbb") || Board.row_to_s(row).include?("rrrr")
    end
    return false
  end

  # check 4 column
  def check_columns
    @grid.transpose.each do |row|
      return true if Board.row_to_s(row).include?("bbbb") || Board.row_to_s(row).include?("rrrr")
    end
    return false
  end

  def check_diagonals
    # store diagonal values in their own arrays
    diags = []

    # get first set of diagonals
    i, j = 3, 0
    while i < @grid.length # 3 to 5
      j = 0
      current_diag = []
      while j <= i
        current_diag << @grid[i-j][j]
        j += 1
      end
      diags << current_diag
      i += 1
    end

    # get second set of diagonals
    (1..3).each do |j|
      i = 5
      temp = j

      current_diag = []
      while temp < @grid[0].length
        current_diag << @grid[i][temp]
        i -= 1
        temp += 1
      end
      diags << current_diag
    end

    # check to see if win in any diagonal
    diags.each do |diag|
      return true if Board.row_to_s(diag).include?("bbbb") || Board.row_to_s(diag).include?("rrrr")
    end

    return false
  end

  # check if tie or win
  def game_over?
    win? || tie?
  end

  def get_current_player_color
    @players.first
  end

  def get_previous_player_color
    @players.last
  end

  def switch_players!
    @players.rotate!
  end

  def display
    system 'clear'
    @grid.each_with_index do |row|
      row.each do |ele|
        if ele.nil?
          print CIRCLE.encode('utf-8').colorize(:black) + ' '
        elsif ele == 'blue'
          print CIRCLE.encode('utf-8').colorize(:blue) + ' '
        elsif ele == 'red'
          print CIRCLE.encode('utf-8').colorize(:red) + ' '
        end
      end
      puts
    end
  end

  def Board.row_to_s(arr)
    string = ""
    arr.each do |val|
      if val.nil?
        string += "x"
      elsif val == "blue"
        string += "b"
      elsif val == "red"
        string += "r"
      end
    end
    string
  end

  def get_column_input
    puts "Enter a column number to drop a piece into: "
    regex = /^[0-6]$/
    input_col = gets.chomp
    
    until regex.match?(input_col) && valid_column(input_col.to_i)
      puts "Invalid input! Enter a non-empty column number from 0 - 6: "
      input_col = gets.chomp
    end

    input_col.to_i
  end

  def play_turn
    # get row from user
    col = get_column_input

    # place piece
    place_piece(col)

    # swap users
    switch_players!
  end

  def play
    until game_over?
      # display board
      display
      # play turn until game over
      play_turn
    end

    display
    puts "Game Over!"
    if win?
      puts "#{get_previous_player_color.capitalize} wins!"
    elsif tie?
      puts "It's a tie!"
    end
  end

end


class InvalidColumnNumberError < StandardError
  def initialize(msg = "Invalid column number")
    super
  end
end

board = Board.new
board.play