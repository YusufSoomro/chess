require_relative 'piece'

class SteppingPiece < Piece

  def moves(directions)
    legal_moves = []

    directions.each do |row, col|
      next_square = [pos[0] + row, pos[1] + col]
      legal_moves << next_square if legal_move?(next_square)
    end

    legal_moves
  end
end
