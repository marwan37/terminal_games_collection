
class Move
  attr_accessor :style, :wins_against, :move

  def >(other)
    self.wins_against.include?(other.move)
  end

  def to_s
    @move
  end

  def style(other)
    @wins_against.each_with_index do |move, i|
      return @style[i] if other.move == move
    end
  end

  def beats
    @wins_against
  end

  def phrase(other)
    @move.capitalize + style(other)
  end
end

class Rock < Move
  def initialize
    @style = [' smashes Scissors.', ' smashes Lizard.']
    @wins_against = ['scissors', 'lizard']
    @move = 'rock'
  end
end

class Paper < Move
  def initialize
    @style = [' covers Rock.', ' disproves Spock.']
    @wins_against = ['rock', 'spock']
    @move = 'paper'
  end
end

class Spock < Move
  def initialize
    @style = [' vaporizes Rock.', ' smashes Scissors.']
    @wins_against = ['rock', 'scissors']
    @move = 'spock'
  end
end

VALUES = { 'rock' => Rock.new, 'paper' => Paper.new, 'spock' => Spock.new }
#  def classify(move)
#   case move
#   when 'rock' then Rock.new
#   when 'paper' then Paper.new
#   when 'spock' then Spock.new
#   end
# end


spock = VALUES['spock']
rock = VALUES['rock']
paper = VALUES['paper']
p paper > spock
p spock.phrase(rock) if paper > rock

# p other_move = Move.new('paper')

# p move.extend(Rules)
# p move.style
