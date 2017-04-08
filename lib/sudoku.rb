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
    until @blocks.all? { |block| block.solved? }
      until @msg_queue.empty?
        msg = @msg_queue.pop

        case msg[:type]
        when :definite
          @blocks.each { |block| block.set_definite( msg[:cell], msg[:value]) }
        else
          fail
        end
      end

      puts Sudoku.pretty_print

      # check if we can infer something new
      @blocks.each { |block| block.infer_definites }

      # if asking to infer has not added new messages, we can't infer any more but need to start guessing.
      return false if @msg_queue.empty?
    end
    return true
  end

  # Every message goes to every queue
  def Sudoku.send_msg( msg )
    @msg_queue ||= []
    @msg_queue << msg
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
