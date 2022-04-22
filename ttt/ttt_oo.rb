$LOAD_PATH.unshift(__dir__)
require "board"
require "modules/displayable"
require "player"
require "square"

# GEMS
require 'terminal-table'
require 'rainbow'
require 'rainbow/refinement'
using Rainbow

=begin
MAIN GAME CLASS
  modules: Displayable (for displaying various messages and joinor method)
  FIRST_TO_MOVE_9
    -only used if user picks 9x9 board
=end
class TTTGame
  include Displayable

  FIRST_TO_MOVE = Player::X_MARKER
  FIRST_TO_MOVE_9 = Player::X_MARKER_9

  attr_reader :board, :human, :computer

  def initialize
    display_welcome_message
    @board = Board.new
    @human = Human.new(board.size)
    @computer = Computer.new(board.size, set_computer_marker)
    @current_marker = (board.size == 9 ? FIRST_TO_MOVE_9 : FIRST_TO_MOVE)
    display_names_and_rules
    @@outcomes = []
  end

  ## MAIN GAME LOOP
  def play
    loop do
      loop do
        play_one_round
        break if winning_score_reached?
        continue_and_switch_markers
      end
      break unless play_again?
      reset_board_and_score
    end
    display_goodbye_message
  end

  # **************** PRIVATE METHODS ****************

  private

  def set_computer_marker
    unless board.size > 5
      return Player::O_MARKER if human.marker == Player::X_MARKER
      return Player::X_MARKER
    end
    human.marker == Player::X_MARKER_9 ? Player::O_MARKER_9 : Player::X_MARKER_9
  end

  # **************** GAME LOOP METHODS ****************

  def play_one_round
    clear_screen_and_display_board
    loop do
      current_player_moves
      clear_screen_and_display_board
      break if board.someone_won? || board.full?
    end
    display_result
  end

  def play_again?
    answer = nil
    puts ""
    puts Rainbow("=> Play again? (y/n)").palegoldenrod
    loop do
      answer = gets.chomp.strip
      break if %w(y n).include?(answer)
      puts "=> Sorry, must type (y) or (n)"
    end
    return change_board_size? if answer.downcase == 'y'
  end

  def human_moves
    puts "Choose a square: [#{joinor(board)}]"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    median = computer.median(board)
    return board[median] = computer.marker if median
    computer.decides_next_move(board)
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = computer.marker
    else
      computer_moves
      sleep 0.03
      @current_marker = human.marker
    end
  end

  def human_turn?
    @current_marker == human.marker
  end

  # switches markers automatically after each round
  def continue_and_switch_markers
    display_continue_message
    human.marker = human.switch_markers
    computer.marker = computer.switch_markers
    reset
  end

  # **************** SCORE CHECK AND OUTCOME DISPLAY METHODS ****************

  def display_score
    puts ""
    human_score = @@outcomes.count('human')
    computer_score = @@outcomes.count('computer')
    str = "#{human.name}: #{human_score}, #{computer.name}: #{computer_score}"
    puts str.magenta
  end

  def winning_score_reached?
    if @@outcomes.count('human') == 3
      puts ""
      animate_title("Congrats #{human.name}, you've reached 3 wins!".green)
    elsif @@outcomes.count('computer') == 3
      puts ""
      animate_title("#{computer.name} has 3 wins. Better luck next time...".red)
    end
    @@outcomes.count('human') == 3 || @@outcomes.count('computer') == 3
  end

  def update_outcome(result)
    animate_title(result)
    case result
    when "#{human.name} won!".green   then @@outcomes << 'human'
    when "#{computer.name} won!".red  then @@outcomes << 'computer'
    end
    display_score
  end

  # **************** BOARD RESET AND SIZE CHANGE METHODS ****************

  def reset
    board.reset
    @current_marker = (board.size == 9 ? FIRST_TO_MOVE_9 : FIRST_TO_MOVE)
    clear
  end

  def reset_board_and_score
    @@outcomes = []
    board.reset
    @current_marker = (board.size == 9 ? FIRST_TO_MOVE_9 : FIRST_TO_MOVE)
    clear
    display_play_again_message
  end

  def change_board_size?
    return new_board_settings if display_user_board_size_change?
    board.reset
    @current_marker = (board.size == 9 ? FIRST_TO_MOVE_9 : FIRST_TO_MOVE)
  end

  def new_board_settings
    board.change_size_and_reset
    @human = Human.new(board.size, human.name)
    @computer = Computer.new(board.size, set_computer_marker)
  end
end

game = TTTGame.new
game.play
