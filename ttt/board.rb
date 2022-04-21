$LOAD_PATH.unshift(__dir__)
require 'game_rules'

=begin
BOARD
  -Generates Square instances and GameRules instance according to user choice
  -insance_variables: @squares, @size, @game_rules, @rows
  -public_methods: draw, []=(num, marker), unmarked_keys, full?, someone_won?
  -public_methods: get_player_marked_squares, winning_marker, reset
  -private_methods+: set_board_size, generate_rows and squares for table
  -private_methods++: change_board_size, all_identical_markers?
=end
class Board
  attr_reader :size, :game_rules
  attr_accessor :rows

  def initialize
    @squares = {}
    @size = set_board_size
    @game_rules = GameRules.new(@size)
    reset
  end

  def draw
    table = Terminal::Table.new do |t|
      t.title = "Tic Tac Toe"
      t.rows = rows
      t.style = { all_separators: true, border: :unicode_thick_edge }
      t.style = { padding_left: 1, padding_right: 1 }
      rows = t.elaborate_rows
      rows[2].border_type = :heavy
    end
    puts table
  end

  # sets 'marker' at index position `num` on the board
  def []=(num, marker)
    @squares[num].marker = marker
  end

  # returns an array of square keys that represent board indexes
  def unmarked_keys
    @squares.select { |_, sq| sq.unmarked? }.keys
  end

  def full?
    unmarked_keys.empty?
  end

  # returns true if winning_marker doesn't return nil
  def someone_won?
    !!winning_marker
  end

  # used by Diligent Computer Module
  def get_marked_squares(player_marker)
    player_squares = []
    @squares.each do |key, sq|
      player_squares << key if sq.marker == player_marker
    end
    player_squares
  end

  # return winning marker or nil
  def winning_marker
    @game_rules.winning_lines.each do |line|
      squares = @squares.values_at(*line)
      return squares.first.marker if all_identical_markers?(squares)
    end
    nil
  end

  # change and reset board size if user chooses to after play_again?
  def change_size_and_reset
    change_board_size
    reset
  end

  # resets game without modifying board size
  def reset
    Square.reset
    @rows = generate_rows
    @squares = format_rows_to_numbered_squares
  end

  # ********************** PRIVATE METHODS **********************

  private

  def set_board_size
    bz = { 9 => '⑨ '.magenta, 5 => '⑤ '.yellow, 3 => '③ '.blue }
    str = "#{bz[3]} for 3x3, #{bz[5]} for 5x5, #{bz[9]} for 9x9"
    puts "=> Pick a board size: " + str
    loop do
      size = gets.chomp.to_i
      return size if [3, 5, 9].include?(size)
      puts "Please pick a valid number: 3, 5 or 9"
    end
  end

  def generate_rows
    (0..size - 1).map do |_|
      (0..size - 1).map { |_| Square.new(@size) }
    end
  end

  def format_rows_to_numbered_squares
    sq_count = size * size
    (1..sq_count).to_a.zip(rows.flatten).to_h
  end

  def change_board_size
    @size = set_board_size
    @game_rules = GameRules.new(@size)
  end

  # true if all squares match to either XXX or OOO
  def all_identical_markers?(squares)
    squares.all? { |sq| sq.marker == Player::X_MARKER } ||
      squares.all? { |sq| sq.marker == Player::O_MARKER }
  end
end
