## GENERATES WINNING LINES ACCORDING TO BOARD SIZE

class GameRules
  attr_reader :winning_lines

  def initialize(size)
    @winning_lines = combined(size)
  end

  # HORIZONTAL WINNING LINES
  def rows(size)
    (1..size).map do |n|
      (size - 1).downto(0).map do |i|
        n * size - i
      end
    end
  end

  # VERTICAL WINNING LINES
  def columns(rows)
    rows.map.with_index do |row, i|
      row.map.with_index do |_, cell|
        rows[cell][i]
      end
    end
  end

  # DIAGONAL WINNING LINES
  def diagonals(rows)
    diagonals = [[], []]
    rows.each_with_index do |row, i|
      diagonals[0] << row[i]
      diagonals[1] << row[-1 - i]
    end
    diagonals
  end

  # ROWS + COLUMNS + DIAGONALS
  def combined(size)
    rows = rows(size)
    rows + columns(rows) + diagonals(rows)
  end
end
