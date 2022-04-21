$LOAD_PATH.unshift(__dir__)
require 'modules/diligent_computer'
=begin
PLAYER
  -includes DiligentComputer module (used by computer only)
  -X_MARKER_9 and O_MARKER_9
    used if user selects 9x9 board, otherwise could overwhelm terminal display
=end

class Player
  attr_accessor :marker
  attr_reader :board_size

  X_MARKER_9 = "Ｘ".red
  O_MARKER_9 = "〇".blue

  X_MARKER = "\n " + "Ｘ".red + " \n "
  O_MARKER = "\n " + "〇".blue + " \n "

  def initialize(board_size)
    @board_size = board_size
  end

  def switch_markers
    return (@marker == X_MARKER ? O_MARKER : X_MARKER) if board_size < 9
    @marker == O_MARKER_9 ? X_MARKER_9 : O_MARKER_9
  end
end

class Human < Player
  def initialize(board_size)
    super(board_size)
    @marker = set_marker
  end

  private

  def set_marker
    marker = nil
    puts ""
    puts "=> Pick a marker: " + "🆇".red + "  or " + "🅾".blue
    puts "=> (or input any other key to have computer pick first)"
    loop do
      marker = gets.chomp
      break if marker =~ /./
      puts "=> Sorry, must input choice."
    end
    adjust_size(marker.strip.downcase)
  end

  def adjust_size(marker)
    return (board_size == 9 ? X_MARKER_9 : X_MARKER) if marker == 'x'
    board_size == 9 ? O_MARKER_9 : O_MARKER
  end
end

class Computer < Player
  include DiligentComputer

  def initialize(board_size, computer_marker)
    super(board_size)
    @marker = computer_marker
  end
end
