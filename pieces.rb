require_relative 'sliding_piece'
require_relative 'stepping_piece'

class Queen < SlidingPiece
  def move_dirs
    moves(ORTHO + DIAGS)
  end

  def inspect
    color == :B ? "♛" : "♕"
  end
end

class Rook < SlidingPiece
  def move_dirs
    moves(ORTHO)
  end

  def inspect
    color == :B ? "♜" : "♖"
  end
end

class Bishop < SlidingPiece
  def move_dirs
    moves(DIAGS)
  end

  def inspect
    color == :B ? "♝" : "♗"
  end
end

class Knight < SteppingPiece
  DELTAS = [
    [2, 1],
    [2, -1],
    [-2, 1],
    [-2, -1],
    [1, 2],
    [1, -2],
    [-1, 2],
    [-1, -2]
  ]

  def move_dirs
    moves(DELTAS)
  end

  def inspect
    color == :B ? "♞" : "♘"
  end
end

class King < SteppingPiece
  def move_dirs
    moves(ORTHO + DIAGS)
  end

  def inspect
    color == :B ? "♚" : "♔"
  end
end

class Pawn < SteppingPiece
  PAWN_WHITE = [
    [-2, 0],
    [-1, 0],
    [-1, 1],
    [-1, -1]
  ]

  PAWN_BLACK = [
    [2, 0],
    [1, 0],
    [1, 1],
    [1, -1]
  ]

  def initialize(pos, board, color)
    super
    @moved = false
  end

  def moved?
    @moved
  end

  def move_dirs
    case color
    when :W
      move(PAWN_WHITE)
    when :B
      move(PAWN_BLACK)
    end
  end

  #Checks pawns legal moves
  def move(direction)
    direction = direction.drop(1) if moved?

    legal_moves = []

    direction.each do |row, col|
      next_spot = [pos[0] + row, pos[1] + col]
      next unless next_spot.all? { |coord| coord.between?(0, 7) }
    
      if col != 0
        next if board[next_spot].nil?
        legal_moves << next_spot if board[next_spot].color == opposite_color
      else
        legal_moves << next_spot if board[next_spot] == nil
      end
    end
    legal_moves
  end

  def inspect
    color == :B ? "♟" : "♙"
  end
end
