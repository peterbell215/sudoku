require 'spec_helper'

RSpec.describe Sudoku::SudokuBlock do
  describe 'INTERESTS' do
    subject { Sudoku::SudokuBlock::INTERESTS }

    it 'should do determine for each cell what other cells in other blocks it effects' do
      expect( subject[0] ).to match_array [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 18, 27, 36, 45, 54, 63, 72 ]
    end
  end

  describe 'BLOCKS' do
    subject { Sudoku::SudokuBlock::BLOCKS}

    it 'should determine for each cell the block it is in' do
      expect( subject[0] ).to eq(0)
      expect( subject[9] ).to eq(0)
      expect( subject[5] ).to eq(1)
    end
  end

  describe '#initialize' do
    subject { Sudoku::SudokuBlock.new(0) }

    it 'should have an array of cells' do
      expect( subject.cells.length ).to eq(9)
      expect( subject.cells[0].nr ).to eq(0)
      expect( subject.cells[5].nr ).to eq(11)
    end
  end
end
