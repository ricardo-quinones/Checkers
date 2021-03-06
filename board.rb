require_relative 'piece'
require 'colorize'

class Board

  attr_accessor :board

  def initialize
    @board = make_board
  end

  def make_board
    Array.new(8) { Array.new(8) }
  end

  def set_board
    [:red, :black].each do |color|
      (0..2).each do |row|
        (0..7).each do |col|
         if row.even?
           next if col.even?
           @board[row][col] = Piece.new(color, [row, col]) if color == :red
           @board[row + 5][col - 1] = Piece.new(color, [row + 5, col - 1]) if color == :black
         elsif row.odd?
           next if col.odd?
           @board[row][col] = Piece.new(color, [row, col]) if color == :red
           @board[row + 5][col + 1] = Piece.new(color, [row + 5, col + 1]) if color == :black
         end
        end
      end
    end
  end

  def render
    @board.each_with_index do |row, index|
      print "#{8 - index} "
      row.each do |piece|
       print (piece.nil? ? "   ".colorize(:background => :green) : " #{piece.symbol.colorize(:backgroud => :white)} ")
      end
      print "\n"
    end
    print "  "
    ("A".."H").each { |letter| print " #{letter} "}
  end

  def empty?(start_pos)
    row, col = start_pos[0], start_pos[1]
    @board[row][col].nil?
  end

  def perform_slide(start_pos, end_pos)
    start_row, start_col = start_pos[0], start_pos[1]
    end_row, end_col = end_pos[0], end_pos[1]

    piece = @board[start_row][start_col]

    @board[start_row][start_col] = nil
    @board[end_row][end_col] = piece
    piece.pos = [end_row, end_col]
  end

  def perform_jump(start_pos, end_pos)
    start_row, start_col = start_pos[0], start_pos[1]
    end_row, end_col = end_pos[0], end_pos[1]

    piece = @board[start_row][start_col]

    @board[start_row][start_col] = nil
    @board[end_row][end_col] = piece
    piece.pos = [end_row, end_col]

    remove_jumped_piece(start_pos, end_pos)
  end

  def remove_jumped_piece(start_pos, end_pos)
    start_row, start_col = start_pos[0], start_pos[1]
    end_row, end_col = end_pos[0], end_pos[1]

    mid_row = (start_row + end_row) / 2
    mid_col = (start_col + end_col) / 2

    jumped_piece = @board[mid_row][mid_col]

    @board[mid_row][mid_col] = nil
  end

  def legal_jump?(start_pos, end_pos)
    start_row, start_col = start_pos[0], start_pos[1]
    end_row, end_col = end_pos[0], end_pos[1]

    piece = @board[start_row][start_col]

    mid_row = (start_row + end_row) / 2
    mid_col = (start_col + end_col) / 2

    if @board[end_row][end_col].nil? && !@board[mid_row][mid_col].nil?
      return true unless @board[mid_row][mid_col].color == piece.color
    end

    false
  end

  def legal_slide?(end_pos)
    end_row, end_col = end_pos[0], end_pos[1]
    @board[end_row][end_col].nil?
  end

  def perform_move(start_pos, end_pos)
    start_row, start_col = start_pos[0], start_pos[1]
    piece = @board[start_row][start_col]

    if piece.slide_moves.include?(end_pos)
      perform_slide(start_pos, end_pos)
      piece.to_king if piece.king_promotion?
    elsif piece.jump_moves.include?(end_pos) && legal_jump?(start_pos, end_pos)
      perform_jump(start_pos, end_pos)
      piece.to_king if piece.king_promotion?
      raise "Play again." if multiple_jumps?(piece)
    else
      raise "You did not select a valid move."
    end
  end

  def legal_move?(turn, start_pos, end_pos)
    start_row, start_col = start_pos[0], start_pos[1]
    end_row, end_col = end_pos[0], end_pos[1]

    if empty?(start_pos)
      raise "The start position is empty."
    elsif @board[start_row][start_col].color != turn
      raise "Move your piece."
    elsif !legal_slide?(end_pos)
      raise "You can't land on a piece."
    else
      true
    end
  end

  def multiple_jumps?(piece)
    start_pos = piece.pos
    piece.jump_moves.any? { |end_pos| legal_jump?(start_pos, end_pos) }
  end

  def any_player_moves?(turn)
    player_pieces = @board.flatten.select { |piece| !piece.nil? && piece.color == turn }
    player_pieces.each do |piece|
      return true if piece.slide_moves.any? { |move| legal_slide?(move) }
      return true if piece.jump_moves.any? { |move| legal_jump?(piece.pos, move) }
    end
  end

  def any_moves?
    any_player_moves?(:red) || any_player_moves(:black)
  end
end