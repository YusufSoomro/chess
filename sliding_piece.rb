require_relative 'piece.rb'

class SlidingPiece < Piece

  # TODO - refactor loop to break after it finds opposite color
  def moves(move_directions)
    legal_moves = []

    move_directions.each do |row, col|
      next_spot = [pos[0] + row, pos[1] + col]
      while legal_move?(next_spot)
        legal_moves << next_spot
        if board[next_spot]
          break if board[next_spot].color == opposite_color
        end
        next_spot = [next_spot[0] + row, next_spot[1] + col]
      end
    end

    legal_moves
  end
end
