class Piece
  ORTHO = [
    [0,1],
    [1,0],
    [0,-1],
    [-1,0]
  ]

  DIAGS = [
    [1,1],
    [1,-1],
    [-1,-1],
    [-1,1]
  ]

  SYMBOLS = {

  }

  attr_reader :color, :board
  attr_accessor :pos

  #Initializes a piece with the position, board, and color
  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  #checks if the given position is a legal move to move to
  def legal_move?(pos)
    return false unless pos.all? { |coord| coord.between?(0, 7) }
    return true if board[pos] == nil
    return false if board[pos].color == color
    true
  end

  # Filters out the moves that will put a piece in check
  def valid_moves(move_dirs)
    move_dirs.select do |end_pos|
      board.move_into_check?(pos, end_pos) == false
    end
  end

  # Returns opposite color of the self
  def opposite_color
    if color == :B
      return :W
    else
      return :B
    end
  end
end
