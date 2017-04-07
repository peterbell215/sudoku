# A SudokuBlock represents a 3x3 grid within the Sudocu grid.  They are numbered as follows:
#
# | 0 | 1 | 2 |
# | 3 | 4 | 5 |
# | 6 | 7 | 8 |
#
module Sudoku
  class SudokuBlock
    # Defines for each cell the other cells of interest
    INTERESTS = (0..80).inject([]) do |interests, cell|
      interests << (0..80).inject([]) do |others, other_cell|
        others << other_cell if other_cell != cell && ( cell/9 == other_cell/9 || cell%9 == other_cell%9)
        others
      end
    end.freeze

    # Defines the block which each cell belongs.
    BLOCKS = (0..80).map{ |cell| [cell, cell/27*3 + cell%9/3] }.to_h.freeze

    def initialize(block)
      @block = block
      @cells = BLOCKS.dup.keep_if{ |cell, block_nr| block_nr==block }.keys.map!{ |block_nr| SudokuCell.new(block_nr) }
    end

    attr_reader :cells

    # msg: {type: <:definite,:guess,:unguess,:contradiction>, field: 13, value: 6}
    def receive(msg)
      if msg[:type]!=:guess
        update_internals(msg)
        find_definites
      else
        guess
      end
    end

    def guess

    end

    def self.interests
      INTERESTS
    end

    private

    def update_internals(msg)
      case msg[:type]
        when :definite

      end
    end
  end
end