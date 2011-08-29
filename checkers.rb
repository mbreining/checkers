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
      validate_move(from, to)
      perform_move(from, to)
    end

    def print_board
      puts "\n"
      puts "  " + (0..7).to_a.join(" ")
      @board.length.times { |i| puts "#{i} " + @board[i].join(" ") }
      puts "\n"
    end

    protected

    def validate_move(from, to)
      from_x, from_y = *from
      to_x, to_y = *to
      if from_x < 0 || from_x > (BOARD_LENGTH-1) || from_y < 0 || from_y > (BOARD_LENGTH-1)
        raise "Invalid move (From position out of bounds)"
      elsif to_x < 0 || to_x > (BOARD_LENGTH-1) || to_y < 0 || to_y > (BOARD_LENGTH-1)
        raise "Invalid move (To position out of bounds)"
      elsif (to_x-from_x).abs != 1
        raise "Invalid move (invalid horizontal move)"
      elsif @move_count.odd? and @board[from_x][from_y] != "o" # white
        raise "Invalid move (square not owned)"
      elsif @move_count.odd? and to_y != from_y-1 # white
        raise "Invalid move (invalid vertical move)"
      elsif !@move_count.odd? and @board[from_x][from_y] != "x" # black
        raise "Invalid move (square not owned)"
      elsif !@move_count.odd? and to_y != from_y+1 # black
        raise "Invalid move (invalid vertical move)"
      elsif @board[to_x][to_y] != "_" # to square is occupied
        raise "Invalid move (square already occupied)"
      end
    end

    def perform_move(from, to)
      from_x, from_y = *from
      to_x, to_y = *to
      @board[from_x][from_y] = "_"
      @board[to_x][to_y] = @move_count.odd? ? "o" : "x"
      @move_count += 1
      # game never ends with current implementation
      @over = true if @black_count == 0 || @white_count == 0
    end
  end
end
