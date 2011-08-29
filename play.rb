#!/usr/local/bin/ruby -w

require_relative 'checkers'

game = Checkers::Game.new
game.print_board

begin
  prompt = "Play #{game.move_count}: "
  prompt << (game.move_count.odd? ? "White (o)" : "Black (x)")
  prompt << ", enter a move (e.g. from 2,2 to 3,3)"
  puts prompt

  while true do
    puts "From: "
    from = gets.chomp
    if from =~ /[0-7],[0-7]/
      break
    else
      puts "ERROR: Invalid input format. Please try again."
    end
  end
  from = from.split(",").map { |i| i.to_i }

  while true do
    puts "To: "
    to = gets.chomp
    if to =~ /[0-7],[0-7]/
      break
    else
      puts "ERROR: Invalid input format. Please try again."
    end
  end
  to = to.split(",").map { |i| i.to_i }

  begin
    game.move_piece(from, to)
  rescue Exception => e
    puts "ERROR: #{e.message}. Please try again."
  end
  game.print_board
end until game.over
