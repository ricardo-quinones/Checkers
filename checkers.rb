require_relative 'board'

class Checkers

  def initialize
    @game = Board.new
    @turn = :black
  end

  def play
    puts "Welcome to Checkers!\n"
    player1, player2 = HumanPlayer.new(:black, 1), HumanPlayer.new(:red, 2)
    @game.set_board

    loop do
      @game.render

      player_turn = (@turn == :black ? player1 : player2)

      move = player_turn.gets_move(@turn)
      move_piece(move)

    end
  end

  def move_piece(move)
    start_pos, end_pos = move[0], move[1]

    if @game.legal_move?(@turn, start_pos, end_pos)
      result = @game.perform_move(start_pos, end_pos)

      @turn = (@turn == :black ? :red : :black) unless result.is_a?(String)
    end
  end
end

class HumanPlayer
  attr_reader :color, :player_num

  def initialize(color, player_num)
    @color = color
    @player_num = player_num
  end

  def gets_move(turn)
    puts "\nPlayer #{self.player_num}, it's your turn.\n".colorize(turn)
    puts "Enter Start and End Position".colorize(turn)

    parse_position(gets.chomp.strip.downcase)
  end

  def parse_position(str)
    strings = [str[/[a-h][1-8]/], str[/[a-h][1-8]$/]]
    move = []
    strings.each do |string|
      pair = []
      string.split("").each do |let_or_num|
        pair << (let_or_num[/\d/] ? -(let_or_num.to_i - 8) : let_or_num.ord - 97)
      end
      move << pair.reverse #reverse because rows & cols != x & y
    end

    move
  end
end

new_game = Checkers.new
new_game.play