class Board

  def self.transform(input)
    @input = input
    validate_input
    board = @input.map(&:chars)
    board.each_with_index do |line, x|
      line.map!.with_index do |cell, y|
        cell == ' ' ? mines_around(x, y) : cell
      end
    end
    board.map(&:join)
  end

  private

  def self.mines_around(x, y)
    mines = 0
    board = @input.map(&:chars)
    (-1..1).each do |i|
      (-1..1).each do |j|
        mines += 1 if board[x+i][y+j] == '*'
      end
    end
    mines == 0 ? ' ' : mines.to_s
  end

  def self.validate_input
    unless board_lines_have_the_same_length?
      fail ValueError,  "Lines should be of the same length"
    end
    unless board_surrounded_by_border?
      fail ValueError,  "Uninterrupted border made with '|', '+' and '-' " \
                        "should surround the board"
    end
    unless board_contains_valid_chars_only?
      fail ValueError,  "Inside the borders only ' ' or '*' " \
                        "characters are allowed"
    end
  end

  def self.board_lines_have_the_same_length?
    @input.all? { |line| line.length == @input.first.length }
  end

  def self.board_surrounded_by_border?
    @input.first  =~ /\A\+[\-]+\+\z/ ||
    @input.last   =~ /\A\+[\-]+\+\z/ ||
    @input[1..-2].all? { |line| line =~ /\A\|.+\|\z/ }
  end

  def self.board_contains_valid_chars_only?
    @input[1..-2].all? { |line| line =~ /\A\|[ \*]+\|\z/ }
  end
end

class ValueError < ArgumentError; end
