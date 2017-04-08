require 'spec_helper'

RSpec.describe Sudoku::SudokuBlock do
  let(:problem) do
    { 0 => 5, 1 => 3, 4=> 7,
      9 => 6, 12 => 1, 13 => 9, 14 => 5,
      19 => 9, 20 => 8, 25 => 6,
      27 => 8, 31 => 6, 35 => 3,
      36 => 4, 39 => 8, 41 => 3, 44 => 1,
      45 => 7, 49 => 2, 53 => 6,
      55 => 6, 60 => 2, 61 => 8,
      66 => 4, 67 => 1, 68 => 9, 71 => 5,
      76 => 8, 79 => 7, 80 => 9
    }
  end

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

    it 'should have a hash of cells' do
      expect( subject.cells.length ).to eq(9)
      expect( subject.cells[0].nr ).to eq(0)
      expect( subject.cells[11].nr ).to eq(11)
    end
  end

  describe '#set_definite' do
    subject { Sudoku::SudokuBlock.new(0) }

    it 'should take account of a cell in the block being set' do
      subject.set_definite(10, 1)

      subject.cells.each_pair do |nr, cell|
        expect( cell.cannot_be ).to match_array(1 ) unless nr==10
      end
    end

    it 'should take account of a cell in the same row in a neighboring block being set' do
      subject.set_definite(5, 1)

      (0..2).each { |cell_nr| expect( subject.cells[cell_nr].cannot_be ).to match_array( 1 ) }
      (9..11).each { |cell_nr| expect( subject.cells[cell_nr].cannot_be ).to be_empty }
      (18..20).each { |cell_nr| expect( subject.cells[cell_nr].cannot_be ).to be_empty }
    end

    it 'should take account of a cell in the same column in a neighboring block being set' do
      subject.set_definite(36, 1)

      (0..18).step(9).each { |cell_nr| expect( subject.cells[cell_nr].cannot_be ).to match_array( 1 ) }
      (1..19).step(9).each { |cell_nr| expect( subject.cells[cell_nr].cannot_be ).to be_empty }
      (2..20).step(9).each { |cell_nr| expect( subject.cells[cell_nr].cannot_be ).to be_empty }
    end
  end

  describe '#infer_definites' do
    subject { Sudoku::SudokuBlock.new(4) }

    it 'should identify definite solutions' do
      expect( Sudoku::SudokuBlock ).to receive(:send).with(type: :definite, cell: 40, value: 5)

      problem.each_pair { |cell, value| subject.set_definite(cell, value) }
      subject.infer_definites
    end
  end
end
