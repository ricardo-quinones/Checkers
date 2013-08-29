require 'colorize'

class Piece
  attr_accessor :pos, :king, :symbol

  attr_reader :color

  def initialize(color, pos)
    @color = color
    @pos = pos
    @king = false
    @symbol = "*".colorize(@color)
  end

  def slide_moves
    i = (@color == :red ? 1 : -1)

    row, col = @pos[0], @pos[1]

    moves = []
    move1, move2 = [row + i, col + 1], [row + i, col - 1]

    moves << move1 if on_board?(move1)
    moves << move2 if on_board?(move2)

    moves
  end

  def jump_moves
    i = (@color == :red ? 2 : -2)

    row, col = @pos[0], @pos[1]

    moves = []
    move1, move2 = [row + i, col + 2], [row + i, col - 2]

    moves << move1 if on_board?(move1)
    moves << move2 if on_board?(move2)

    moves
  end

  def on_board?(move)
    row, col = move[0], move[1]

    row.between?(0,7) && col.between?(0,7)
  end
end