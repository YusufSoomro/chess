require_relative "board"
require 'yaml'

class Game

  attr_reader :board

  # Initializes the game with a new board.
  def initialize
    @board = Board.new
  end

  #gets input from user and asserts that coord is on the board
  def get_input
    begin
      puts "What's the location of the piece you want to move"
      from_pos = gets.chomp
      if from_pos.downcase == "q"
        puts "Quitting the game."
        exit
      elsif from_pos.downcase == 's'
        save
        raise InvalidInputError.new("You just saved the file. Continue playing.")
      end
      puts "What's the location you want to move the piece to?"
      to_pos = gets.chomp

      from_pos, to_pos =
            [from_pos.split(" ").map(&:to_i), to_pos.split(" ").map(&:to_i)]


      assert_input_valid?(from_pos)
      assert_input_valid?(to_pos)

      [from_pos, to_pos]
    rescue InvalidInputError => e
      puts e.message
      retry
    end
  end

  # asserts valid input
  def assert_input_valid?(piece_pos)
    unless piece_pos.all? { |coord| coord.between?(0,7) }
      raise InvalidInputError.new "That is not a valid position on the board"
    end
  end

  # plays the game, entering a loop, breaking if somebody won or someone
  # typed 'q' for quit
  def play
    puts "Welcome! You're playing CHHHHHHEEEESSSS!!"
    puts "Enter your input like this '1 2'"
    board.display
    loop do
      break if turn(:W)
      break if turn(:B)
    end
    puts "Game Over!!!!"
  end

  # asks a player for their turn
  def turn(color)
    begin
      puts "It is #{color}'s turn"
      from, to = get_input
      board.check_legal_move?(from, to)
      if board[from].color != color
        raise IllegalMoveError.new "It is #{board[from].opposite_color}'s turn you cheater."
      end
      board.move(from, to)
      board.display
      if board.in_check?(board[to].opposite_color)
        puts "#{board[to].opposite_color} is in check."
        if board.checkmate?(board[to].opposite_color)
          puts "Checkmate, #{color} wins"
          return true
        end
      end
    rescue IllegalMoveError => e
      puts e.message
      retry
    end
  end

  #saves the game as a YAML file
  def save
    puts "What do you want save your file under?"
    filename = gets.chomp
    File.write("#{filename}.yml", self.to_yaml)
  end

  # class function that loads a YAML file back into a game object
  def self.load
    puts "What file do you want to load?"
    filename = gets.chomp
    YAML.load_file("#{filename}.yml")
  end
end


class InvalidInputError < ArgumentError
end

# If this file is run from the command line, asks user to load a game,
# or start a new game.
if __FILE__ == $PROGRAM_NAME
  puts "Do you want to load (l) a file or start new game (n)?"
  puts "(l/n)"
  choice = gets.chomp

  if choice == 'l'
    g = Game.load
    g.play
  else
    g = Game.new
    g.play
  end
end
