require 'terminal-table'

INITIAL_MARKER = "\n\n     "
HUMAN_MARKER = "\n  ❌ \n  "
COMPUTER_MARKER = "\n  🔵 \n  "

class Square
  INITIAL_MARKER = "\n\n     "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end
end

rows = (0..2).map {|_| [Square.new, Square.new, Square.new] }
squares = (1..9).to_a.zip(rows.flatten).to_h
# hsh =  { 1 =>rows[0][0], 2 => rows[0][1], 3 => rows[0][2],
#          4 =>rows[1][0], 5 => rows[1][1], 6 => rows[1][2],
#          7 =>rows[2][0], 8 => rows[2][1], 9 => rows[2][2] }

p squares[1].marker = "x"

def gen_table(rows)
  table = Terminal::Table.new :title => "Tic Tac Toe", :rows => rows
  table.style = {:all_separators => true}
  table.style = { :border => :unicode_thick_edge }
  rows = table.elaborate_rows
  rows[2].border_type = :heavy
  puts table
end

gen_table(rows)
