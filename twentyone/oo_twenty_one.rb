require 'terminal-table'
require 'rainbow'

module Displayable
  # *************************** SYSTEM  ****************************
  # CLEAR TERMINAL, SHORTCUT METHODS FOR PROMPTS & COLOR
  def clear
    puts "amit"
    if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
      system('cls')
    else
      system('clear')
    end
  end

  def prompt(message)
    puts("=> #{message}")
  end

  def color_prompt(string, color=:goldenrod)
    prompt Rainbow(string).bright.color(color)
  end

  def color(string, sym=:whitesmoke)
    Rainbow(string).color(sym).bright
  end

  # ****************** GAME LOOP RELATED DISPLAYS ******************
  # SHOW RESULTS / SHOW BUSTED / DISPLAY COINBOARD AT END OF GAME
  def show_result
    result = dealer.hand.total <=> player.hand.total
    display_final_coinboard(result)
    case result
    when -1 then color_prompt("#{player.name} wins!", :lime)
    when 1 then color_prompt("#{dealer.name} wins!", :crimson)
    else color_prompt("It's a tie!", :yellow)
    end
    sleep 1
    puts ""
  end

  def display_final_coinboard(result)
    case result
    when -1 then coinboard.player_wins
    when  1 then coinboard.dealer_wins
    else         coinboard.tie
    end
    clear
    show_cards(-1)
    sleep 1
  end

  def show_busted
    animate_player_bust if player.busted?
    animate_dealer_bust if dealer.busted?
  end

  # ****************** INTRO/OUTRO RELATED DISPLAYS ******************
  # ****** GREETING PROMPTS / MESSAGES / GOODBYE / ANIMATABLES *******
  def greet_player
    puts ""
    msg = color(dealer.name + ': ', :goldenrod)
    greetings = color("Greetings #{player.name}!")
    animate(msg + greetings, " I'll be your croupier today.")
    2.times { puts "" }
    sleep 1
    explain_betting(msg)
    display_continue_message
  end

  def explain_betting(msg)
    animate(msg, "As a welcome token, here's")
    animate_letters(color(' ＄100!', :limegreen))
    2.times { puts "" }
    sleep 1
    animate(msg, 'Bets are placed before each flop. ')
    animate_letters(color('Minimum bet is', :linen), 0.03)
    animate_letters(color(' ＄10.', :limegreen))
    sleep 1
    2.times { puts "" }
  end

  def animate_letters(str, del=0.05)
    str.each_char do |letter|
      print letter
      sleep del
    end
  end

  def animate(str1, str2, color=:linen)
    print str1
    sleep 1
    str2.each_char do |letter|
      print Rainbow(letter).color(color).bright
      sleep 0.03
    end
    sleep 0.8
  end

  def animate_intro
    clear
    word = " Welcome to Twenty-One!"
    sleep 0.5
    print("\r")
    print "🚀                            " + "\r"
    animate_letters(color("🚀 RB120:", :crimson))
    animate_letters(color(word, :linen), 0.04)
    puts ""
    sleep 0.5
  end

  def display_goodbye_message
    puts ""
    puts color("Thank you for playing Twenty-One. Goodbye!", :khaki)
  end
end

module DisplayableParticipant
  # *********************** PLAYER *************************
  # ********** PROMPTS RELATING TO PLAYER STATUS ***********

  def player_decides_to_stay?
    prompt "Would you like to #{color('(h)')}it or #{color('(s)')}tay?"
    answer = nil
    loop do
      answer = gets.chomp.strip
      break if %w(h hit s stay).include?(answer.downcase)
      prompt 'Please enter a valid input (h to hit, s to stay)'
    end
    puts ""
    answer.downcase == 's'
  end

  def animate_player_bust
    coinboard.dealer_wins
    clear
    show_cards(-1)
    player_bust = "=> " + color("Busted!", :red)
    animate(player_bust, " #{dealer.name} wins!", :red)
    sleep 1
    2.times { puts "" }
  end

  def display_game_number
    color_prompt("Twenty-One!", :goldenrod)
    puts ""
    sleep 1
    display_continue_message
  end

  def display_final_player_status
    return show_busted if player.busted?
    return display_game_number if player.game_number?
    show_player_cards_only(0)
    puts color("#{player.name}: #{color('Stay!')}", :aqua)
    sleep 2
  end

  # *** prompt at end fo each game loop - continue or 'quit' ***
  def play_again?
    color_prompt("Press any key to continue! ", :seashell)
    puts Rainbow("=> (you can also type 'quit' to cash out)").dimgray
    answer = gets.chomp
    answer.strip.downcase != 'quit'
  end

  def show_out_of_coins
    sleep 1
    msg = "=> " + color("You ran out of coins...", :crimson)
    animate(msg, " :(", :crimson)
    sleep 1
    2.times { puts "" }
  end

  # called if player is out of coins or ::play_again? == 'quit'
  def start_over?
    answer = nil
    color_prompt("Would you like to reset and start over? (y/n)", :seashell)
    loop do
      answer = gets.chomp.downcase.strip
      break if ['y', 'n'].include? answer
      puts "Sorry, must be y or n."
    end
    answer == 'y'
  end

  def display_continue_message
    color_prompt("Press any key to continue...", :khaki)
    gets
    clear
  end

  # *********************** DEALER *************************
  # ***** PROMPTS/MESSAGES RELATING TO DEALER/COMPUTER *****

  def display_showing_dealer
    color_prompt("Showing #{dealer.name}'s hand...", :goldenrod)
    sleep 2
    clear
  end

  def dealer_stays
    msg1 = color(dealer.name + ': ', :goldenrod)
    animate(msg1, 'Stay!', :linen)
    sleep 1
    2.times { puts "" }
  end

  def animate_dealer_bust
    coinboard.player_wins
    clear
    show_cards(-1)
    dealer_bust = "=> " + color("Busted!", :crimson)
    animate(dealer_bust, " #{player.name} wins!", :lime)
    sleep 1
    2.times { puts "" }
  end

  def display_dealer_hits
    sleep 1
    header = color(dealer.name + ': ', :goldenrod)
    animate(header, 'Hit!', :linen)
    sleep 1
    clear
  end

  def display_dealer_stays
    sleep 1
    msg1 = color(dealer.name + ': ', :goldenrod)
    animate(msg1, 'Stay!', :linen)
    sleep 1
  end
end

class Coinboard
  #  uses terminal-table to display player's name/coins/pot
  #  set_pot method asks player to place a bet
  #  if player's coins <=10, minimum bet of 10 is placed automatically
  #  player_wins/dealer_wins/tie methods display live coinboard updates
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

class Participant
  attr_accessor :name, :hand, :turn, :coins

  def initialize
    @hand = Hand.new
    @name = set_name
    @turn = (player? ? true : false)
    @coins = 100
  end

  def busted?
    hand.total > 21
  end

  def game_number?
    hand.total == 21
  end

  # Show total when n = -1 / only show first card value when n = -2
  # used to animate total as cards are dealt and to hide dealer's total at first
  def display_heading(n=-1)
    rgb = (turn ? :goldenrod : :darkslategray)
    heading = "---- #{name}'s Hand ---- (#{hand.total(n)})"
    print Rainbow(heading).bright.color(rgb)
    puts ""
  end

  def player?
    self.class == Player
  end
end

class Player < Participant
  def set_name
    puts ""
    answer = nil
    loop do
      puts "=> " + Rainbow("What's your name?").bright.color(:goldenrod)
      puts ""
      answer = gets.chomp.strip
      return answer unless answer.empty?
      puts "Sorry, must enter a value."
    end
  end

  # When n = -1, show all cards
  # When n = -2, show one card only
  def shows_hand(n)
    display_heading
    if n < -1
      hand.show_slowly(n)
    else
      hand.show_slowly
    end
    puts ""
  end
end

class Dealer < Participant
  def set_name
    ['Le Chiffre', 'The Cypher'].sample
  end

  def shows_hand(n)
    display_heading(n)
    n > -2 ? hand.show_slowly(n) : hand.hide_one
    puts ""
  end

  def stays?
    hand.total >= 17 && !busted?
  end
end

class Card
  attr_reader :face

  SUITS = ['♥', '♦', '♠', '♣']
  FACES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']

  def initialize(suit, face)
    @suit = suit
    @face = face
  end

  def suit
    case @suit
    when '♥' then Rainbow('♥').color(:red)
    when '♦' then Rainbow('♦').color(:crimson)
    when '♠' then Rainbow('♠').color(:mintcream)
    when '♣' then Rainbow('♣').color(:palegreen)
    else ' '
    end
  end

  def self.hidden
    <<-TPL.gsub(/^\s+/, '')
    ┌─────────┐
    │░░░░░░░░░│
    │░░░░░░░░░│
    │░░░░░░░░░│
    │░░░░░░░░░│
    │░░░░░░░░░│
    └─────────┘
    TPL
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity
  def to_s
    # A simple template with X's as placeholders for suit glyphs
    # YY represents the placement of the card's face
    template = <<-TPL.gsub(/^\s+/, '')
      ╭─────────╮
      │ X  X  X │
      │  X X X  │
      │ X  YY X │
      │         │
      │ X  X  X │
      ╰─────────╯
    TPL

    # the patterns represent the configuration of glyphys
    # X means place a glyph, _ means clear the space
    case @face.to_i
    when 2  then  '_X_______X_'
    when 3  then  '_X__X____X_'
    when 4  then  'X_X_____X_X'
    when 5  then  'X_X_X___X_X'
    when 6  then  'X_XX_X__X_X'
    when 7  then  'X_X_X_XXX_X'
    when 8  then  'X_XX_XXXX_X'
    when 9  then  'X_XXXXXXX_X'
    when 10 then  'XXXX_XXXXXX'
    else          'X_________X'
    end
      .each_char do |c|
      # replace X's with glyphs
      if c == 'X'
        template.sub!(/X/, suit.to_s)
      # replace _'s with whitespace
      else
        template.sub!(/X/, " ")
      end
    end

    # place the card face (left-padded)
    template.sub!(/YY/, face.ljust(2))
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity

  def ace?
    face == 'A'
  end

  def king?
    face == 'K'
  end

  def queen?
    face == 'Q'
  end

  def jack?
    face == 'J'
  end
end

class String
  def next(str)
    # zip strings and split with line breaks
    zipped = split("\n").zip(str.split("\n"))
    # map zipped strings by joining each pair
    # end with a new line then join again
    zipped.map { |e| e.join.to_s }.join "\n"
  end
end

class Hand
  attr_accessor :cards

  def initialize(cards = [])
    @cards = []
    cards.each do |card|
      self << card
    end
  end

  def draw(deck, n = 1)
    n.times do
      @cards << deck.draw
    end
    self
  end

  def to_s
    @cards.map(&:to_s).inject(:next)
  end

  # only for animation purposes
  def show_slowly(n=-1)
    puts @cards[0..n].map(&:to_s).inject(:next)
  end

  # used to hide one card from dealer's flop
  def hide_one
    puts [@cards[0], Card.hidden].map(&:to_s).inject(:next)
  end

  def total(n=-1)
    total = 0
    cards[0..n].each do |card|
      total += 11 if card.ace?
      total += 10 if card.jack? || card.queen? || card.king?
      total += card.face.to_i if card.face.to_i.to_s == card.face
    end

    correct_for_aces(total)
  end

  private

  def correct_for_aces(total)
    cards.select(&:ace?).count.times do
      break if total <= 21
      total -= 10
    end
    total
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = set_cards
  end

  def set_cards
    @cards = []
    Card::SUITS.each do |suit|
      Card::FACES.each do |face|
        @cards << Card.new(suit, face)
      end
    end

    cards.shuffle!
  end

  def draw
    cards.pop
  end
end

# ****************** MAIN GAME ******************

class TwentyOne
  include Displayable
  include DisplayableParticipant

  attr_accessor :deck, :coinboard
  attr_reader :player, :dealer

  def initialize
    animate_intro
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
    @coinboard = Coinboard.new(player)
  end

  def start
    greet_player
    loop do
      play_one_hand
      break unless start_over?
      full_reset
    end
    display_goodbye_message
  end

  # ******************* PRIVATE METHODS *******************

  private

  def play_one_hand
    loop do
      coinboard.set_pot
      deal_cards
      player_turn
      dealer_turn unless player.busted?
      show_result unless someone_busted?
      break show_out_of_coins if player.coins.zero?
      break unless play_again?
      reset
    end
  end

  def reset
    clear
    @deck = Deck.new
    player.hand = Hand.new
    dealer.hand = Hand.new
    alternate_turns
  end

  # used when start_over?=>true, resets player's coin to 100
  def full_reset
    @coinboard = Coinboard.new(player)
    @player.coins = 100
    reset
  end

  # ******** ANIMATE DISPLAYING OF CARDS/COINBOARD ********
  def deal_cards
    display_coinboard
    player.hand.draw(deck, 1)
    dealer.hand.draw(deck, 2)
    show_initial_flop_slowly
  end

  def show_initial_flop_slowly
    dealer.shows_hand(-2)
    sleep 1
    player.display_heading
    player.hand.show_slowly(0)
    player.hand.draw(deck, 1)
    sleep 1
    show_player_cards_only(0)
    sleep 0.5
  end

  def show_player_cards_only(delay=0.5)
    clear
    display_coinboard
    dealer.shows_hand(-2)
    sleep(delay)
    player.shows_hand(-1)
  end

  def show_cards(n)
    display_coinboard
    dealer.shows_hand(n)
    player.shows_hand(n)
    show_player_cards_only if n < -1
  end

  def display_coinboard
    coinboard.draw
  end

  # *************** PLAYER AND DEALER TURNS ***************
  def player_turn
    loop do
      break if player.game_number? || player.busted?
      sleep 0.5
      break if player_decides_to_stay?
      player.hand.draw(deck, 1)
      show_player_cards_only(0)
    end
    display_final_player_status
    alternate_turns
  end

  def alternate_turns
    player.turn = !player.turn
    dealer.turn = !dealer.turn
  end

  def dealer_turn
    show_player_cards_only(0)
    display_showing_dealer
    show_cards(-1)
    loop do
      break if dealer.busted? || dealer.stays?
      dealer_hits
      show_cards(-1)
    end
    show_busted if dealer.busted?
  end

  def dealer_hits
    dealer.hand.draw(deck, 1)
    display_dealer_hits
  end

  def someone_busted?
    player.busted? || dealer.busted?
  end
end

game = TwentyOne.new
game.start
