class Board

  def self.transform(input)
    validate(input)

    board = input.map(&:chars)
    board.each_with_index do |line, y|
      line.each_with_index do |cell, x|
        next if "*|-+".include? cell
        mines_around = 0
        (-1..1).each do |i|
          (-1..1).each do |j|
            mines_around += 1 if board[y+j][x+i] == "*"
          end
        end
        board[y][x] = mines_around.to_s unless mines_around == 0
      end
    end

    board.map(&:join)
  end

  private

  def self.validate(input)
    unless input.all? { |line| line.length == input.first.length }
      fail ValueError,  "Lines should be of the same length"
    end
    unless input.all? { |line| line =~ /[\+\-]+/ || line =~ /\A\|.+\|\z/ }
      fail ValueError,  "Uninterrupted borders made with '|', '+' and '-' " \
                        "should surround the board"
    end
    unless input.all? { |line| line =~ /[\+\-]+/ || line =~ /\A\|[ \*]+\|\z/ }
      fail ValueError,  "Inside the borders only ' ' or '*' " \
                        "characters are allowed"
    end
  end

end

class ValueError < ArgumentError; end
