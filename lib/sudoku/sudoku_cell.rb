module Sudoku
  class SudokuCell
    def initialize(nr)
      @nr = nr

      @definite = nil
      @guesses = []
      @cannot_be = []
    end

    attr_reader :nr
  end
end
