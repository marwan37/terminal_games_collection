$LOAD_PATH.unshift(__dir__)

require 'displayable'
require 'terminal-table'
require 'rainbow'
require 'pry'

=begin
Coinboard class
  -uses terminal-table to display player's name/coins/pot
  -set_pot by asking player to place a bet
  -if player's coins <=10, minimum bet of 10 placed automatically
  -player_wins/dealer_wins/tie methods display live game outcome updates
=end
class Coinboard
  include Displayable

  attr_accessor :pot, :table
  attr_reader :player

  def initialize(player)
    @player = player
  end

  def draw
    @table = generate_table
    puts table
    puts ""
  end

  def name_adjust
    return "'" if player.name[-1].downcase == 's'
    "'s"
  end

  def display_betting_rules
    clear
    str = color("＄#{player.coins}", :springgreen)
    puts color("#{player.name}#{name_adjust} balance: #{str}", :goldenrod)
    puts ""
    range_str = Rainbow("(10-#{player.coins}): ").webgray
    print "=> #{color('Place your bet!', :goldenrod)} #{range_str}"
  end

  def set_pot
    return place_minimum_bet if (0..10).cover?(player.coins)
    display_betting_rules
    answer = nil
    loop do
      answer = gets.chomp
      break if (10..player.coins).cover?(answer.to_i)
      puts "=> Sorry, must input number between 10 and #{player.coins}."
    end
    @pot = answer.to_i
    clear
  end

  def place_minimum_bet
    msg = "Minimum bet of #{player.coins} placed automatically."
    color_prompt(msg, :goldenrod)
    sleep 1
    set_pot(amount)
  end

  def tie
    @pot = color("0".center(11), :darkslategray)
  end

  def player_wins
    player.coins += pot
    @pot = color("+#{pot}".center(11), :lime)
  end

  def dealer_wins
    player.coins -= pot
    @pot = color("-#{pot}".center(11), :red)
  end

  private

  def generate_table
    @table = Terminal::Table.new do |t|
      pl = Rainbow(player.name.center(12)).dodgerblue.bright
      t << [pl, { value: "$#{player.coins}", alignment: :center }]
      t.rows[0] << @pot.to_s.center(11)
      t.style = { width: 45, all_separators: true, border: :unicode_round }
      t.style.border[:se] = '$'
    end
  end
end
