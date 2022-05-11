class String
  def next(str)
    # zip the two strings, split by line breaks
    zipped = split("\n").zip(str.split("\n"))

    # map the zipped strings, by joining each pair and ending
    #   with a new line, then joining the whole thing together
    zipped.map { |e| e.join.to_s }.join "\n"
  end
end

class Card
  # include Displayable

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
