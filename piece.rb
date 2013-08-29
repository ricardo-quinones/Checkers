# encoding: UTF-8
require 'colorize'

class Piece
  attr_accessor :pos, :king, :symbol

  attr_reader :color

  def initialize(color, pos)
    @color = color
    @pos = pos
    @king = false
    @symbol = "●"
  end

  def slide_moves
    row, col = @pos[0], @pos[1]

    moves = []
    move1, move2 = [row + 1, col + 1], [row + 1, col - 1]
    move3, move4 = [row - 1, col + 1], [row - 1, col - 1]

    red_moves, black_moves = [], []

    red_moves << move1 if on_board?(move1)
    red_moves << move2 if on_board?(move2)
    black_moves << move3 if on_board?(move3)
    black_moves << move4 if on_board?(move4)

    if @king
      moves = red_moves + black_moves
    elsif @color == :red
      moves = red_moves
    elsif @color == :black
      moves = black_moves
    end
    p "my moves are "
    p moves
    moves
  end

  def jump_moves
    row, col = @pos[0], @pos[1]

    moves = []
    move1, move2 = [row + 2, col + 2], [row + 2, col - 2]
    move3, move4 = [row - 2, col + 2], [row - 2, col - 2]

    red_moves, black_moves = [], []

    red_moves << move1 if on_board?(move1)
    red_moves << move2 if on_board?(move2)
    black_moves << move3 if on_board?(move3)
    black_moves << move4 if on_board?(move4)

    if @king
      moves = red_moves + black_moves
    elsif @color == :red
      moves = red_moves
    elsif @color == :black
      moves = black_moves
    end

    moves
  end

  def on_board?(move)
    row, col = move[0], move[1]
    row.between?(0,7) && col.between?(0,7)
  end

  def king_promotion?
    (@pos[0] == 0 && @color == :black) || (@pos[0] == 7 && @color == :red)
  end

  def to_king
    @king = true
    @symbol = "○"
  end
end