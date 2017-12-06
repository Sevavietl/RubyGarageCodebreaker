require 'tempfile'
require_relative 'storage_spec'

RSpec.describe Codebreaker::Storage::CsvStorage do
  subject { described_class.new(file.path) }
  let(:file) { Tempfile.new('scores') }

  describe '#initialize' do
    it 'accepts file name' do
      filename = 'scores.csv'
      subject = described_class.new(filename)

      expect(subject.send(:filename)).to eq(filename)
    end
  end

  it_behaves_like 'a storage' do
    after do
      file.close
      file.delete
    end
  end
end
