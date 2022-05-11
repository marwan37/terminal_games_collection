class Hand
  include Displayable

  class String
    def next(str)
      # zip the two strings, split by line breaks
      zipped = split("\n").zip(str.split("\n"))

      # map the zipped strings, by joining each pair and ending
      #   with a new line, then joining the whole thing together
      zipped.map { |e| e.join.to_s }.join "\n"
    end
  end

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
