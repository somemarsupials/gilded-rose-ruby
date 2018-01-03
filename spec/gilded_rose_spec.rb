require File.join(File.dirname(__FILE__), '..', 'lib', 'gilded_rose')

describe GildedRose do
  let(:typed_item) { double(:typed_item) }
  let(:item) { double(:item) }
  let(:factory) { double(:typed_factory, generate: typed_item) }
  subject { described_class.new([item] * 5, factory) }

  describe '#initialize' do
    before(:each) do
      allow_any_instance_of(described_class)
        .to receive(:convert).and_return([typed_item])
    end

    describe 'when created' do
      it 'converts items' do
        expect(subject.items).to eq [typed_item]
      end
    end
  end

  describe '#update' do
    before(:each) do
      allow_any_instance_of(described_class)
        .to receive(:convert).and_return([typed_item] * 4)
    end

    describe 'when updating' do
      after(:each) { subject.update }

      it 'calls update on each item' do
        expect(typed_item).to receive(:update).exactly(4).times
      end
    end
  end
  
  describe '#convert' do
    describe 'when converting items' do
      subject { described_class.new([], factory) }
      after(:each) { subject.convert([item] * 3, factory) }
      
      it 'passes each item to the factory' do
        expect(factory).to receive(:generate).with(item).exactly(3).times
      end
    end
  end
end
