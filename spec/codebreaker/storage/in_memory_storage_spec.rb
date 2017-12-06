require_relative 'storage_spec'

RSpec.describe Codebreaker::Storage::InMemoryStorage do
  subject { described_class.new }

  describe '#initialize' do
    it 'initializes empty data array for storing records' do
      expect(subject.send(:data)).to be_an(Array)
      expect(subject.send(:data).size).to eq(0)
    end
  end

  it_behaves_like 'a storage'
end
