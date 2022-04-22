## COMPUTER HAS ARTIFICIAL INTELLIGENCE: in Player/Computer Class only
# computer methods: median(board) for first move, can_win?, should_defend?

module ArtificialIntelligence
  def can_win?(board)
    computer_squares = board.get_marked_squares(@marker)
    board.game_rules.winning_lines.each do |line|
      ai_remain = line - computer_squares
      if ai_remain.size == 1
        return ai_remain[0] if board.unmarked_keys.include?(ai_remain[0])
      end
    end
    nil
  end

  def should_defend?(board)
    human_squares = board.get_marked_squares(switch_markers)
    board.game_rules.winning_lines.each do |line|
      remain = line - human_squares
      if remain.size == 1
        return remain[0] if board.unmarked_keys.include?(remain[0])
      end
    end
    nil
  end

  def checks_optimal_move(board)
    attack = can_win?(board)
    defend = should_defend?(board)
    return attack if attack
    return defend if defend
    nil
  end

  def decides_next_move(board)
    optimal_move = checks_optimal_move(board)
    return board[optimal_move] = @marker if optimal_move
    board[board.unmarked_keys.sample] = @marker
  end

  # calculates median (middle board marker) for first move
  def median(board)
    size = board.size * board.size
    sorted = (1..size).to_a
    mid = (sorted.length - 1) / 2.0
    val = (sorted[mid.floor] + sorted[mid.ceil]) / 2.0
    return val.to_i if board.unmarked_keys.include?(val)
    nil
  end
end
