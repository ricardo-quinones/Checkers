require_relative 'piece'

class Board
  attr_accessor :board
  def initialize
    @board = make_board
  end

  def make_board
    Array.new(8) { Array.new(8) }
  end

  def set_board
    [:red, :blue].each do |color|
      (0..2).each do |row|
        (0..7).each do |col|
         if row.even?
           next if col.even?

           @board[row][col] = Piece.new(color, [row, col]) if color == :red
           @board[row + 5][col] = Piece.new(color, [row + 5, col]) if color == :blue
         elsif row.odd?
           next if col.odd?

           @board[row][col] = Piece.new(color, [row, col]) if color == :red
           @board[row + 5][col] = Piece.new(color, [row + 5, col]) if color == :blue
         end
        end
      end
    end
  end

  def render
    @board.each_with_index do |row, index|
      print "#{8 - index} "
      row.each do |piece|
       print (piece.nil? ? " _ " : " #{piece.symbol} ")
      end
      print "\n"
    end
    print "  "
    ("A".."H").each { |letter| print " #{letter} "}
  end

  def perform_slide(start_pos, end_pos)
    start_row, start_col = start_pos[0], start_pos[1]
    end_row, end_col = end_pos[0], end_pos[1]
    p @board[start_row][start_col]
    piece = @board[start_row][start_col]

    if piece.slide_moves.include?(end_pos)
      @board[start_row][start_col] = nil
      @board[end_row][end_col] = piece
      piece.pos = [end_row, end_col]
      p piece
    else

      nil
    end
  end

  def perform_move(start_pos, end_pos)
    perform_slide(start_pos, end_pos)
  end
end

# match = Board.new
# match.set_board
# match.render