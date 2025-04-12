class Mancala
  attr_accessor :board, :current_player

  def initialize
    # Each player has 6 pits, index 6 and 13 are the stores
    @board = Array.new(14, 4)
    @board[6] = 0  # Player 1's store
    @board[13] = 0 # Player 2's store
    @current_player = 1
  end

  def display_board
    puts "\n       [12][11][10][9][8][7]"
    print " P2   "
    print @board[12..7].reverse.map { |s| format("%2d", s) }.join("  ")
    puts
    puts "[13] #{@board[13]}                          #{@board[6]} [6]"
    print " P1   "
    print @board[0..5].map { |s| format("%2d", s) }.join("  ")
    puts
    puts "       [0] [1] [2] [3][4][5]"
  end

  def valid_move?(pit)
    return false unless pit.between?(0, 5) && current_player == 1
    return false if @board[pit] == 0
    true
  end

  def valid_move_p2?(pit)
    return false unless pit.between?(7, 12) && current_player == 2
    return false if @board[pit] == 0
    true
  end

  def move(pit)
    stones = @board[pit]
    @board[pit] = 0
    pos = pit

    while stones > 0
      pos = (pos + 1) % 14

      # Skip opponent's store
      if current_player == 1 && pos == 13
        next
      elsif current_player == 2 && pos == 6
        next
      end

      @board[pos] += 1
      stones -= 1
    end

    # Last stone landed in player's own store: take another turn
    if (current_player == 1 && pos == 6) || (current_player == 2 && pos == 13)
      puts "🎯 Free turn!"
    else
      @current_player = 3 - @current_player
    end
  end

  def game_over?
    @board[0..5].all?(&:zero?) || @board[7..12].all?(&:zero?)
  end

  def collect_remaining
    @board[6] += @board[0..5].sum
    @board[13] += @board[7..12].sum
    @board[0..5] = Array.new(6, 0)
    @board[7..12] = Array.new(6, 0)
  end

  def winner
    if @board[6] > @board[13]
      "Player 1 wins! 🎉"
    elsif @board[13] > @board[6]
      "Player 2 wins! 🎉"
    else
      "It’s a tie!"
    end
  end

  def play
    until game_over?
      display_board
      puts "\n👤 Player #{@current_player}'s turn."

      move_valid = false
      until move_valid
        print "Choose a pit (P#{@current_player}): "
        pit = gets.chomp.to_i

        if current_player == 1 && valid_move?(pit)
          move_valid = true
          move(pit)
        elsif current_player == 2 && valid_move_p2?(pit)
          move_valid = true
          move(pit)
        else
          puts "Invalid move. Try again."
        end
      end
    end

    collect_remaining
    display_board
    puts "\n🏁 Game over! #{winner}"
  end
end

# Start the game
game = Mancala.new
game.play
