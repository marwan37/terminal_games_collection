require 'rainbow'
require 'rainbow/refinement'
using Rainbow

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

  # ***************  UNMARKED ARRAY NUMBERS ***************

  def joinor(board, delimiter = ', ', word = ' or ')
    numbers = board.unmarked_keys
    word = (numbers.size == 1 ? '' : word)
    array = numbers[-numbers.size..-2]
    numbers = "#{array.join(delimiter)}#{word}#{numbers.last}"
    Rainbow(numbers).dimgray
  end

  # *************** DISPLAY GENERAL MESSAGES ***************

  def display_welcome_message
    clear
    animate_title("Welcome to Tic Tac Toe!")
    puts ""
  end

  def display_names_and_rules
    animate_name("#{human.marker.strip} Human: " + "#{human.name}!")
    animate_name("#{computer.marker.strip} Computer: " + "#{computer.name}!")
    puts ""
    display_game_score_limit
    display_continue_message
  end

  def display_game_score_limit
    puts ""
    animate_title("First to " + "3".green + " wins.")
  end

  def display_continue_message
    puts ""
    puts Rainbow("=> Press any key to continue...").cornsilk
    gets.chomp
  end

  def display_play_again_message
    animate_title(Rainbow("Let's play again!").palegoldenrod)
    puts ""
    sleep 0.5
  end

  def display_goodbye_message
    puts ""
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  # *************** DISPLAY SCORE AND GAME RESULT ***************

  def display_result
    case board.winning_marker
    when human.marker    then update_outcome("#{human.name} won!".green)
    when computer.marker then update_outcome("#{computer.name} won!".red)
    else                      update_outcome("It's a tie!".yellow)
    end
  end

  # *************** DISPLAY BOARD AND CLEAR  ***************

  def display_board
    markers = [human.marker.strip, computer.marker.strip]
    puts "#{human.name} is #{markers[0]}. #{computer.name} is a #{markers[1]}."
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_user_board_size_change?
    puts ""
    puts Rainbow("=> Change board size? (y/n)").palegoldenrod
    answer = nil
    loop do
      answer = gets.chomp
      break if %w(y n).include?(answer)
      puts "=> Sorry, must type (y) or (n)"
    end
    answer.downcase.strip == 'y'
  end

  # *************** ANIMATE STRING AND NAME ***************

  def animate_name(title)
    puts ""
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
