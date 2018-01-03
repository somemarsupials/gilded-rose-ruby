require File.join(File.dirname(__FILE__), '..', 'lib', 'typed_factory') 

describe TypedItemFactory do
  let(:item) { double(:item, name: 'default') }
  let(:typed_item) { double(:typed_item) }
  let(:type) { double(:klass, new: typed_item) }
  subject { described_class.new({ /hello/ => :a, /bye/ => :b }) }

  describe '#generate' do
    before(:each) { allow(subject).to receive(:identify).and_return(type) }

    describe 'when generating items' do
      after(:each) { subject.generate(item) }

      it 'calls identify with item name' do
        expect(subject).to receive(:identify).with('default')
      end

      it 'creates new typed item with item' do
        expect(type).to receive(:new).with(item)
      end
    end

    describe 'when returning values' do
      it 'generates new object with given type' do
        expect(subject.generate(item)).to eq typed_item
      end
    end
  end

  describe '#identify' do
    describe 'when identifying item' do
      it 'uses regex to find match' do
        expect(subject.identify('hello', :default)).to eq :a
      end

      it 'returns default value when not matching' do
        expect(subject.identify('nothing', :default)).to eq :default
      end
    end
  end
end
