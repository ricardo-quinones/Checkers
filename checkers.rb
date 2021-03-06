require_relative 'board'

class Checkers

  def initialize
    @board = Board.new
    @turn = :black
    @players = {black: HumanPlayer.new(:black, 1), red: HumanPlayer.new(:red, 2)}
  end

  def play
    puts "Welcome to Checkers!\n"
    @board.set_board

    loop do
      @players[@turn].play_turn(@board)
      break if game_over?
      @turn = (@turn == :black ? :red : :black)
    end
    @board.render
    if player_won?
      puts "\nCongratulations Player #{@players[@turn].player_num}. You won!"
    else
      puts "\nThe match is a draw."
    end
  end

  def player_won?
    pieces = @board.board.flatten.compact
    return true if pieces.none? { |piece| piece.color == :red } || pieces.none? { |piece| piece.color == :black }
  end

  def draw?
    !@board.any_moves?
  end

  def game_over?
    player_won? || draw?
  end
end

class HumanPlayer
  attr_reader :player_num

  def initialize(color, player_num)
    @color = color
    @player_num = player_num
  end

  def play_turn(board)
    if board.any_player_moves?(@turn)
      begin
        puts "\nPlayer #{self.player_num}, it's your turn.\n".colorize(@color)
        board.render
        move = gets_move

        start_pos, end_pos = move[0], move[1]

        if board.legal_move?(@color, start_pos, end_pos)
          board.perform_move(start_pos, end_pos)
        end
      rescue StandardError => e
        puts e.message
        retry
      end
    else
      puts "\nSorry Player #{self.player_num}, You have no moves."
    end
  end

  def gets_move
    puts "\nEnter Start and End Position".colorize(@color)

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