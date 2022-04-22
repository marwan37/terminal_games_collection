=begin SQUARE
  -attr_accessor: marker (for individual board markers)
  -private method colored_sq(size)
    adjusts square size according to board size
    (size refers to board_size)
=end

class Square
  @@square_count = 0

  attr_accessor :marker

  def initialize(size)
    @@square_count += 1
    @marker = colored_sq(size)
  end

  def to_s
    @marker
  end

  def unmarked?
    markers = ['Ｘ', '〇']
    marker.chars.none? { |c| markers.include?(c) }
  end

  def self.reset
    @@square_count = 0
  end

  # **************** PRIVATE METHODS ****************

  private

  def colored_sq(size)
    colored = Rainbow(@@square_count.to_s).dimgray
    return colored if size > 5
    return " \n " + colored + " \n " if @@square_count > 9
    " \n #{colored}  \n "
  end
end
