require 'colorize'

=begin DISPLAYABLE
  module included in BOARD and TTTGame classes
  - methods for displaying messages, animating strings, displaying board
  - additional methods: clear terminal, joinor (shows unmarked_keys with 'or')
=end

module Displayable
  def clear
    puts "amit"
    if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
      system('cls')
    else
      system('clear')
    end
  end

  def joinor(board, delimiter = ', ', word = ' or ')
    numbers = board.unmarked_keys
    word = (numbers.size == 1 ? '' : word)
    array = numbers[-numbers.size..-2]
    numbers = "#{array.join(delimiter)}#{word}#{numbers.last}"
    numbers.light_black
  end

  def display_names
    puts ""
    animate_name("#{human.marker.strip} Human: " + "#{human.name}!")
    puts ""
    animate_name("#{computer.marker.strip} Computer: " + "#{computer.name}!")
    puts ""
    display_game_score_limit
    display_continue_message
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_continue_message
    puts ""
    puts "=> Press any key to continue...".cyan
    gets.chomp
  end

  def switch_markers?
    display_continue_message
    answer = gets.chomp
    answer.downcase.strip == 'o'
  end

  def user_wants_to_change_board_size?
    puts ""
    puts "=> Would you like to change the board size? (y/n)".yellow
    answer = nil
    loop do
      answer = gets.chomp
      break if %w(y n).include?(answer)
      puts "=> Sorry, must type (y) or (n)"
    end
    answer.downcase.strip == 'y'
  end

  def display_welcome_message
    clear
    animate_title("Welcome to Tic Tac Toe!")
    puts ""
  end

  def display_game_score_limit
    puts ""
    animate_title("First to " + "5".green + " wins.")
  end

  def display_goodbye_message
    puts ""
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_play_again_message
    animate_title("Let's play again!".yellow)
    puts ""
    sleep 0.5
  end

  def animate_name(title)
    title.each_char do |letter|
      print letter
      sleep(0.03)
    end
  end

  def animate_title(title)
    title.each_char do |letter|
      print letter
      sleep(0.03)
    end
    puts ""
  end
end
