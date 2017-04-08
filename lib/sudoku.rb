require 'sudoku/version'
require 'sudoku/sudoku_block'
require 'sudoku/sudoku_cell'

module Sudoku
  # We work in two phases:
  # 1) We find definite constraints and solve as much of the problem this way.
  # 2) We then try guessing.
  def Sudoku.run(problem)
    @blocks = Array.new(9) { |i| SudokuBlock.new(i) }

    problem.each_pair do |cell, value|
      Sudoku.send_msg( type: :definite, cell: cell, value: value )
    end

    phase1
  end

  # Keep picking off until we are done
  def Sudoku.phase1
    until Sudoku.solved? || @msg_queue.empty?
      until @msg_queue.empty?
        msg = @msg_queue.pop

        case msg[:type]
        when :definite
          @blocks.each { |block| block.receive_msg( msg ) }
        else
          fail
        end
      end

      # check if we can infer something new
      @blocks.each { |block| block.receive_msg( type: :infer_definites ) }
    end

    return Sudoku.solved?
  end

  # Every message goes to every queue
  def Sudoku.send_msg( msg )
    @msg_queue ||= []
    @msg_queue << msg
  end

  def Sudoku.solved?
    @blocks.all?( &:solved? )
  end

  def Sudoku.pretty_print
    (0..80).inject('') do |string, cell|
      string << '|' if cell % 3 == 0
      string << (@blocks[SudokuBlock::BLOCKS[cell]].cells[cell].definite || ' ').to_s
      string << "|\n" if [8, 17].include?( cell % 27 )
      string << "|\n#{'|---' * 3}|\n" if cell % 27 == 26
      string
    end + "\n"
  end
end

Sudoku.run( 0 => 5, 1 => 3, 4=> 7,
             9 => 6, 12 => 1, 13 => 9, 14 => 5,
             19 => 9, 20 => 8, 25 => 6,
             27 => 8, 31 => 6, 35 => 3,
             36 => 4, 39 => 8, 41 => 3, 44 => 1,
             45 => 7, 49 => 2, 53 => 6,
             55 => 6, 60 => 2, 61 => 8,
             66 => 4, 67 => 1, 68 => 9, 71 => 5,
             76 => 8, 79 => 7, 80 => 9 )

puts Sudoku.pretty_print