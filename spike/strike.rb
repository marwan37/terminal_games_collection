
require 'terminal-table'

def generate_table(moves, ai)
  rows = []
  choices = {"rock"=>0, 'paper'=>1, 'scissors'=>2, 'lizard'=>3, 'spock'=>4}
  table = Terminal::Table.new do |t|
    t << ['Rock']
    t.add_row ['Paper']
    t.add_row ['Scissors']
    t.add_row ['Lizard']
    t.add_row ['Spock']
    t.style = {:all_separators => true}
  end

  moves.zip(ai).each do |m|
    table.rows.each_with_index do |row, i|
      if choices[m[0]] == i && choices[m[1]] == i
        row << "T"
      elsif choices[m[0]] == i
        row << "H"
      elsif choices[m[1]] == i
        row <<  "C"
      else
        row << ""
      end
   end
  end
end
