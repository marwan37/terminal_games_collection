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
      return answer.capitalize unless answer.empty?
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
