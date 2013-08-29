require_relative 'board'

class Checkers

  def initialize
    @game = Board.new
    @turn = :blue
  end

  def play
    puts "Welcome to Checkers!\n"
    player1, player2 = HumanPlayer.new(:blue, 1), HumanPlayer.new(:red, 2)
    @game.set_board

    while true
      @game.render

      player_turn = (@turn == :blue ? player1 : player2)

      move = player_turn.gets_move

      start_pos, end_pos = move[0], move[1]

      @game.perform_move(start_pos, end_pos)

      @turn = (@turn == :blue ? :red : :blue)
    end
  end
end

class HumanPlayer
  attr_reader :color, :player_num

  def initialize(color, player_num)
    @color = color
    @player_num = player_num
  end

  def gets_move
    puts "\nPlayer #{self.player_num}, it's your turn.\n".colorize(@turn)
    puts "Enter Initial and End Position".colorize(@turn)

    parse_position(gets.chomp.strip.downcase)
  end

  def parse_position(str)
    strings = [str[/\D\d/], str[/\D\d$/]]
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