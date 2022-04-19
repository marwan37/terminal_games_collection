require 'colorize'
require 'terminal-table'

def clear
  puts "amit"
  if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
    system('cls')
  else
    system('clear')
  end
end

def generate_table(moves, ai, results)
  choices = { 'rock' => 0, 'paper' => 1, 'scissors' => 2,
              'lizard' => 3, 'spock' => 4 }
  table = Terminal::Table.new do |t|
    t.headings = results
    t.rows = choices.keys.map(&:capitalize).map { |m| [m] }
    t.style = { all_separators: true }
  end

  update_table(table, choices, moves.zip(ai))
  puts table
end

def cell_value(human_choice, computer_choice, row_index)
  return "⩵" if human_choice == row_index && computer_choice == row_index
  return "🗿" if human_choice == row_index
  return "👾" if computer_choice == row_index
  "  "
end

def update_table(table, choices, moves)
  moves.each do |m|
    table.rows.each_with_index do |row, i|
      row << cell_value(choices[m[0]], choices[m[1]], i)
    end
  end
end

def animate_title(title, delay)
  title.each_char do |letter|
    print letter
    sleep(delay)
  end
  puts ""
end

module Personable
  def assign_personality(name)
    choices = ["rock", "paper", "scissors", "lizard", "spock"]
    case name
    when 'R2D2' then Hash[choices.zip([0.6, 0.1, 0.1, 0.1, 0.1])]
    when 'Hal' then Hash[choices.zip([0.1, 0.1, 0.6, 0.1, 0.1])]
    when 'Chappie' then Hash[choices.zip([0.1, 0.4, 0.3, 0.1, 0.1])]
    when 'Sonny' then Hash[choices.zip([0.2, 0.5, 0.1, 0.1, 0.1])]
    when 'Number 5' then Hash[choices.zip([0.03, 0.03, 0.03, 0.7, 0.2])]
    end
  end

  def gen_weighted_sample(name)
    arr = []
    hsh = assign_personality(name)
    50.times { arr << hsh.max_by { |_, weight| rand**(1.0 / weight) }.first }
    arr
  end
end

class Score
  attr_accessor :human, :computer

  def initialize
    @human = 0
    @computer = 0
  end
end

module Moves
  class Move
    attr_reader :wins_against, :move

    def >(other)
      @wins_against.include?(other.move)
    end

    def to_s
      @move
    end

    def style(other)
      @wins_against.each_with_index do |move, i|
        return @style[i] if other.move == move
      end
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

  class Scissors < Move
    def initialize
      @style = [' decapitates Lizard.', ' cuts Paper.']
      @wins_against = ['lizard', 'paper']
      @move = 'scissors'
    end
  end

  class Spock < Move
    def initialize
      @style = [' vaporizes Rock.', ' smashes Scissors.']
      @wins_against = ['rock', 'scissors']
      @move = 'spock'
    end
  end

  class Lizard < Move
    def initialize
      @style = [' poisons Spock.', ' eats Paper.']
      @wins_against = ['spock', 'paper']
      @move = 'lizard'
    end
  end
end

class Player
  VALUES = { 'rock' => Moves::Rock.new, 'paper' => Moves::Paper.new,
             'spock' => Moves::Spock.new, 'scissors' => Moves::Scissors.new,
             'lizard' => Moves::Lizard.new }
  CHOICES = { 'r' => 'rock', 'p' => 'paper', 'sp' => 'spock',
              's' => 'scissors', 'l' => 'lizard' }

  attr_accessor :move, :name, :moves

  def initialize
    set_name
    @moves = []
  end
end

class Human < Player
  def set_name
    n = ""
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
    animate_title("🗿 Human: " + "#{name}!".blue, 0.03)
  end

  def choose
    choice = nil
    loop do
      puts "Choose (r)ock, (p)aper, (s)cissors, (l)izard, or (sp)ock:".yellow
      choice = CHOICES[gets.chomp.strip]
      break if VALUES.keys.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = VALUES[choice]
    @moves << @move.to_s
    puts "#{@name} chose " + "#{@move}.".blue
  end
end

class Computer < Player
  include Personable
  attr_accessor :weighted_choices

  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
    self.weighted_choices = gen_weighted_sample(@name)
    sleep 0.5
    animate_title("🤖 Opponent: " + "#{@name}!".red, 0.03)
    animate_title("First to " + "10 ".green + "wins.", 0.03)
    animate_title("Press any key to start:", 0.03)
    gets
  end

  def choose
    self.move = VALUES[@weighted_choices.sample]
    @moves << @move.to_s
    sleep 0.5
    puts "#{@name} chose " + "#{@move}.".red
  end
end

class RPSGame
  attr_accessor :human, :computer, :score, :results

  def initialize
    clear
    display_welcome_message
    @results = ['  MOVES  '.black.on_white]
    @human = Human.new
    @computer = Computer.new
    @score = Score.new
    clear
  end

  def display_welcome_message
    animate_title("Welcome to Rock, Paper, Scissors, Lizard, Spock!", 0.03)
  end

  def display_winner
    if human.move > computer.move
      @results << '🗿'.on_blue
      human_won
    elsif computer.move > human.move
      @results << '👾'.on_red
      computer_won
    else
      puts "It's a tie!".yellow
      @results << '⩵'
    end
  end

  def human_won
    score.human += 1
    puts human.move.phrase(computer.move).green
    puts "#{human.name} won!".green
  end

  def computer_won
    score.computer += 1
    puts computer.move.phrase(human.move).red
    puts "#{computer.name} won!".red
  end

  def update_score
    puts "#{score.human}-#{score.computer}"
    puts "Press any key to continue..."
    gets
    clear
  end

  def display_move_history
    generate_table(human.moves, computer.moves, @results)
  end

  def display_final_result
    clear
    if score.human > score.computer
      animate_title("Congrats! You win!".green, 0.04)
    else
      animate_title("Better luck next time...", 0.04)
    end
    sleep 1
  end

  def play_one_round
    display_move_history
    human.choose
    computer.choose
    display_winner
    update_score
  end

  def reset_stats
    @results = ['  MOVES  '.black.on_white]
    @score = Score.new
    human.moves = []
    computer.moves = []
    @computer = Computer.new
    clear
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end
    answer == 'y'
  end

  def play
    loop do
      loop do
        play_one_round
        break if [score.human, score.computer].include? 10
      end
      display_final_result
      break if !play_again?
      reset_stats
    end
    puts "Thanks for playing Rock, Paper, Scissors, Lizard, Spock. Good bye!"
  end
end

RPSGame.new.play
