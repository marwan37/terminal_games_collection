$LOAD_PATH.unshift(__dir__)
require 'card'
require 'participant'
require 'displayable'
require 'displayable_player'
require 'hand'
require 'coins'

require 'rainbow'

# ****************** MAIN GAME CLASS/ LOOPS ******************
class TwentyOne
  include Displayable
  include DisplayableParticipant

  attr_accessor :deck, :coinboard
  attr_reader :player, :dealer

  def initialize
    # animate_intro
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
    @coinboard = Coinboard.new(player)
  end

  def start
    # greet_player
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
