require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    # winner is not next_mover_mark
    return false if @board.tied?
    return @board.winner != evaluator if @board.over?


    puts "Evaluator: #{evaluator}"
    puts "Next mover: #{@next_mover_mark}"
    if evaluator == @next_mover_mark
      # puts "in the wrong place"
      children.all? do |child|
        child.losing_node?(evaluator)
      end
    else
      # puts "in the right place"
      children.any? do |child|
        child.losing_node?(evaluator)
      end
    end
  end

  def winning_node?(evaluator)
    return @board.winner == evaluator if @board.over?

    child_nodes = children

    if evaluator == @next_mover_mark
      child_nodes.any? do |child|
        child.winning_node?(evaluator)
      end
    else

    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    children_list = []
    empty_spaces = get_empty_spaces
    empty_spaces.each do |pos|
      new_board = @board.dup
      new_board[pos] = @next_mover_mark
      new_node_mark = toggle_mark(@next_mover_mark)
      children_list << TicTacToeNode.new(new_board, new_node_mark, pos)
    end
    children_list
  end

  private

  def get_empty_spaces
    empty_spaces = []
    @board.rows.each_with_index do |row, r|
      row.each_index do |c|
        empty_spaces << [r, c] if @board.empty?([r, c])
      end
    end
    empty_spaces
  end

  def toggle_mark(mark)
    mark == :x ? :o : :x
  end
end
