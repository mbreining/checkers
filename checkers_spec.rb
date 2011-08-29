require_relative 'checkers'

describe Checkers::Game do
  before(:each) { @game = Checkers::Game.new }

  describe "#initialize" do
    it "creates an 8x8 board" do
      @game.board.length.should == 8
      @game.board.length.times do |i|
        @game.board[i].length.should == 8
      end
    end
    it "initializes the board w/ black and white pieces" do
      @game.board[0][0].should == "x"
      @game.board[7][7].should == "o"
    end
    it "initializes the move count to 0" do
      @game.move_count.should == 0
    end
    it "starts a new game" do
      @game.over.should be_false
    end
  end

  describe "#move_piece" do
    context "when from position is out of bounds" do
      it "raises an error" do
        expect {
          @game.move_piece([9,9], [1,1])
        }.to raise_error
      end
    end
    context "when to position is out of bounds" do
      it "raises an error" do
        expect {
          @game.move_piece([1,1], [9,9])
        }.to raise_error
      end
    end
    context "when to_x value is invalid" do
      it "raises an error" do
        expect {
          @game.move_piece([2,2], [0,3])
        }.to raise_error
      end
    end
    context "when piece on from position is not owned" do
      it "raises an error" do
        expect {
          @game.board[2][2] = "o"
          @game.move_piece([2,2], [3,3])
        }.to raise_error
        expect {
          @game.move_count = 1
          @game.board[2][2] = "x"
          @game.move_piece([2,2], [3,3])
        }.to raise_error
      end
    end
    context "when to_y value is invalid" do
      it "raises an error" do
        expect {
          @game.move_piece([2,2], [3,2])
        }.to raise_error
        expect {
          @game.move_count = 1
          @game.move_piece([1,5], [0,5])
        }.to raise_error
      end
    end
    context "when square on to position is already occupied" do
      it "raises an error" do
        expect {
          @game.move_piece([1,1], [2,2])
        }.to raise_error
      end
    end
    context "when the move is valid" do
      it "clears the from square" do
        @game.move_piece([2,2], [3,3])
        @game.board[2][2].should == "_"
      end
      it "sets the to square" do
        @game.move_piece([2,2], [3,3])
        @game.board[3][3].should == "x"
      end
      it "increments the move count by 1" do
        expect {
          @game.move_piece([2,2], [3,3])
        }.to change { @game.move_count }.from(0).to(1)
      end
      context "when there are no more white pieces" do
        it "ends the game" do
          expect {
            @game.white_count = 0
            @game.move_piece([2,2], [3,3])
          }.to change { @game.over }.from(false).to(true)
        end
      end
      context "when there are no more black pieces" do
        it "ends the game" do
          expect {
            @game.black_count = 0
            @game.move_piece([2,2], [3,3])
          }.to change { @game.over }.from(false).to(true)
        end
      end
    end
  end
end
