#spec/connect_four_spec.rb
require './lib/connect_four.rb'

# create a board class with 6x7 array, Board.grid should be 2d array (6x7)

describe Board do
  describe '#grid' do
    it "returns reference to an array" do
      board = Board.new
      expect(board.grid.class).to eql(Array)
    end

    it "length of grid array is 6" do
      board = Board.new
      expect(board.grid.length).to eq(6)
    end

    it "each of grid's inner arrays is length 7" do
      board = Board.new
      expect(board.grid.all?{|row| row.length == 7}).to eq(true)
    end
  end

  describe '#valid_column' do
    it "takes a column number as an argument" do
      board = Board.new
      expect { board.valid_column(0) }.to_not raise_error
    end

    it "returns false when column number is invalid" do
      board = Board.new
      expect { board.valid_column(10) }.to raise_error(InvalidColumnNumberError)
      expect { board.valid_column(-1) }.to raise_error(InvalidColumnNumberError)
      expect { board.valid_column(7) }.to raise_error(InvalidColumnNumberError)
    end

    it "returns true when column is not full" do
      board = Board.new
      expect(board.valid_column(0)).to eql(true)
      expect(board.valid_column(5)).to eql(true)
    end

    it "returns false when column is full" do
      board = Board.new
      6.times {board.place_piece(0)}
      expect(board.valid_column(0)).to eql(false)
    end
  end

  describe '#place_piece' do
    it "takes a column number as an argument" do
      board = Board.new
      expect { board.place_piece(0) }.to_not raise_error
    end

    it "raises error when column number is invalid" do
      board = Board.new
      expect {board.place_piece(-1)}.to raise_error(InvalidColumnNumberError)
      expect {board.place_piece(8)}.to raise_error(InvalidColumnNumberError)
      expect {board.place_piece("not_a_number")}.to raise_error(InvalidColumnNumberError)
    end

    it "returns false when column is not valid (is full)" do
      board = Board.new
      6.times {board.place_piece(0)}
      expect(board.place_piece(0)).to eql(false)
    end
  end

  describe '#get_current_player_color' do
    it "takes no arguments" do
      board = Board.new
      expect { board.get_current_player_color ("arg") }.to raise_error(ArgumentError)
    end

    it "returns the current player" do
      board = Board.new
      expect(board.get_current_player_color).to eq("blue")
      board.switch_players!
      expect(board.get_current_player_color).to eq("red")
    end
  end

  describe '#switch_players!' do
    it "swaps the players" do
      board = Board.new
      expect(board.get_current_player_color).to eq("blue")
      board.switch_players!
      expect(board.get_current_player_color).to eq("red")
    end
  end

  describe '#tie?' do
    it 'returns true when board is full' do
      board = Board.new
      (0..6).each do |num|
        6.times {board.place_piece(num)}
      end

      expect(board.tie?).to eq(true)
    end

    it 'returns false when there\'s a win' do
    end

    it 'returns false when board is not full' do
      board = Board.new
      expect(board.tie?).to eq(false)
    end
  end

  describe '#win?' do
    it 'returns true when a player has won' do
      board = Board.new
      4.times {board.place_piece(0)}
      expect(board.win?).to eq(true)
    end

    it 'returns false when no player has won' do
      board = Board.new
      3.times {board.place_piece(0)}
      expect(board.win?).to eq(false)
    end
  end

end