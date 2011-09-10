module Checkers
  BOARD_LENGTH = 8

  class Game
    attr_accessor :board, :move_count, :black_count, :white_count, :over

    def initialize
      @board = Array.new(BOARD_LENGTH) { Array.new(BOARD_LENGTH, "_") }
      @board.length.times do |i|
        if i.odd?
          @board[i][1], @board[i][5], @board[i][7] = "x", "o", "o"
        else
          @board[i][0], @board[i][2], @board[i][6] = "x", "x", "o"
        end
      end
      @move_count = 0
      @black_count, @white_count = 12, 12
      @over = false
    end

    def move_piece(from, to)
      move = Move.factory(from, to, self)
      if move.valid?
        move.perform
      else
        raise "Invalid move"
      end
    end

    def print_board
      puts "\n"
      puts "  " + (0..7).to_a.join(" ")
      @board.length.times { |i| puts "#{i} " + @board[i].join(" ") }
      puts "\n"
    end
  end

  class Move
    attr_accessor :from, :to

    def initialize(from, to, game)
     @from, @to, @game = from, to, game
     @from_x, @from_y, @to_x, @to_y = *from, *to
    end

    def self.factory(from, to, game)
      from_x, from_y, to_x, to_y = *from, *to
      if (to_x-from_x).abs == 1
        SimpleMove.new(from, to, game)
      elsif (to_x-from_x).abs % 2 == 0
        JumpMove.new(from, to, game)
      end
    end

    def valid?
      if @from_x < 0 || @from_x > (BOARD_LENGTH-1) || @from_y < 0 || @from_y > (BOARD_LENGTH-1)
        #raise "Invalid move (From position out of bounds)"
        return false
      elsif @to_x < 0 || @to_x > (BOARD_LENGTH-1) || @to_y < 0 || @to_y > (BOARD_LENGTH-1)
        #raise "Invalid move (To position out of bounds)"
        return false
      elsif @game.move_count.odd? and @game.board[@from_x][@from_y] != "o" # white
        #raise "Invalid move (square not owned)"
        return false
      elsif !@game.move_count.odd? and @game.board[@from_x][@from_y] != "x" # black
        #raise "Invalid move (square not owned)"
        return false
      elsif @game.board[@to_x][@to_y] != "_" # to square is occupied
        #raise "Invalid move (square already occupied)"
        return false
      end
      true
    end

    def perform
      @game.board[@from_x][@from_y] = "_"
      @game.board[@to_x][@to_y] = @game.move_count.odd? ? "o" : "x"
      @game.move_count += 1
      # game never ends with current implementation
      @game.over = true if @game.black_count == 0 || @game.white_count == 0
    end
  end

  class SimpleMove < Move
    def valid?
      return false unless super
      if @game.move_count.odd? and @to_y != @from_y-1 # white
        #raise "Invalid move (invalid vertical move)"
        return false
      elsif !@game.move_count.odd? and @to_y != @from_y+1 # black
        #raise "Invalid move (invalid vertical move)"
        return false
      end
      true
    end
  end

  class JumpMove < Move
    def valid?
      return false unless super
      if @game.move_count.odd? and @to_y != @from_y-2 # white
        return false
      elsif !@game.move_count.odd? and @to_y != @from_y+2 # black
        return false
      end
      true
    end

    def perform
      super
      if @to_x > @from_x
        @game.board[@to_x-1][@to_y-1] = "_"
      else
        @game.board[@to_x+1][@to_y-1] = "_"
      end
    end
  end
end
