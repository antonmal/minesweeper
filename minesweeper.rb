class Board
  attr_reader :input, :cells

  def initialize(input)
    @input = input
    @cells = input.map(&:chars)
  end

  def self.transform(input)
    board = Board.new(input)
    board.validate
    board.cells.map.with_index do |line, x|
      line.map.with_index do |cell, y|
        cell == ' ' ? board.mines_around(x, y) : cell
      end
    end.map(&:join)
  end

  def mines_around(x, y)
    mines = 0
    (-1..1).each do |i|
      (-1..1).each do |j|
        mines += 1 if cells[x+i][y+j] == '*'
      end
    end
    mines == 0 ? ' ' : mines.to_s
  end

  def validate
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

  def board_lines_have_the_same_length?
    input.all? { |line| line.length == input.first.length }
  end

  def board_surrounded_by_border?
    input.first  =~ /\A\+[\-]+\+\z/ &&
    input.last   =~ /\A\+[\-]+\+\z/ &&
    input[1..-2].all? { |line| line =~ /\A\|.+\|\z/ }
  end

  def board_contains_valid_chars_only?
    input[1..-2].all? { |line| line =~ /\A\|[ \*]+\|\z/ }
  end
end

class ValueError < ArgumentError; end
