
module Sudoku
  # A SudokuBlock represents a 3x3 grid within the Sudocu grid.  They are numbered as follows:
  #
  # | 0 | 1 | 2 |
  # | 3 | 4 | 5 |
  # | 6 | 7 | 8 |
  #
  class SudokuBlock
    # Defines for each cell the other cells of interest
    INTERESTS = (0..80).inject([]) do |interests, cell|
      interests << (0..80).inject([]) do |others, other_cell|
        others << other_cell if other_cell != cell && (cell / 9 == other_cell / 9 || cell % 9 == other_cell % 9)
        others
      end
    end.freeze

    # Defines the block which each cell belongs.
    BLOCKS = (0..80).map { |cell| [cell, cell / 27 * 3 + cell % 9 / 3] }.to_h.freeze

    def initialize(block)
      @block = block
      @still_to_place = (1..9).to_a
      @cells = BLOCKS.dup
                 .keep_if{ |cell, block_nr| block_nr==block }
                 .map{ |cell, block_nr| [cell, SudokuCell.new(cell) ] }.to_h
    end

    attr_reader :cells

    # msg: {type: <:definite, :guess, :unguess, :contradiction>, field: 13, value: 6}

    def set_definite(cell_nr, value)
      if @cells[cell_nr]
        @cells[cell_nr].definite = value
        @still_to_place.delete value
        @cells.each_pair { |nr, cell| cell.cannot_be << value unless nr == cell_nr }
      else
        INTERESTS[cell_nr].each { |affected_cell| @cells[affected_cell].cannot_be << value if @cells[affected_cell] }
      end
    end

    def infer_definites
      possible_solutions = {}

      @cells.each_pair do |cell_nr, cell|
        possible_solutions[cell_nr] = @still_to_place - cell.cannot_be unless cell.definite
      end

      possible_solutions.each_pair do |cell_nr, poss_solutions|
        Sudoku.send_msg(type: :definite, cell: cell_nr, value: poss_solutions.first) if poss_solutions&.length==1
      end
    end

    def solved?
      @still_to_place.empty?
    end
  end
end