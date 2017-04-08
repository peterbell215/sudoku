module Sudoku
  class SudokuCell
    def initialize(nr)
      @nr = nr

      @definite = nil
      @guesses = []
      @cannot_be = []
    end

    attr_reader :nr
    attr_accessor :definite
    attr_accessor :cannot_be
    attr_accessor :guesses
  end
end
