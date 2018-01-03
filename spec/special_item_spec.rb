require File.join(File.dirname(__FILE__), '..', 'lib', 'special_item')
require File.join(File.dirname(__FILE__), 'default_item_spec')

describe LegendaryItem do
  include_examples 'default item'

  let(:item) { double(:item, :sell_in= => nil, :quality= => nil) }
  subject { described_class.new(item, params) }

  describe '#update_quality' do
    before(:each) { subject.update_quality }

    it 'does not change quality' do
      expect(item).to_not receive(:quality=)
    end
  end

  describe '#update_sell_in' do
    before(:each) { subject.update_sell_in }

    it 'does not change quality' do
      expect(item).to_not receive(:sell_in=)
    end
  end
end

describe AgedBrieItem do
  include_examples 'default item'

  describe '#initialize (subclass)' do
    before(:each) { described_class.new(item, params, multiplier: -1) }

    describe 'when created' do
      it 'multiplies increment by multiplier' do
        expect(subject.params[:quality_incr]).to eq -3
      end
    end
  end
end

describe BackstagePassesItem do
  include_examples 'default item'

  subject do 
    described_class.new(item, params, five_or_less: 5, ten_or_less: 10)
  end

  describe '#initialize (subclass)' do
    before(:each) do 
      described_class.new(item, params, five_or_less: 5, ten_or_less: 10)
    end

    describe 'when created' do
      it 'sets five_or_less' do
        expect(subject.params[:incr_5_or_less]).to eq 5
      end
      
      it 'sets ten_or_less' do
        expect(subject.params[:incr_10_or_less]).to eq 10
      end
    end
  end

  describe '#update_quality' do
    before(:each) { allow(item).to receive(:quality).and_return(0) }
    after(:each) { subject.update_quality }

    describe 'when sell-in is below threshold' do
      before(:each) { allow(item).to receive(:sell_in).and_return(-5) }

      it 'sets quality to 0' do
        expect(item).to receive(:quality=).with(0)
      end
    end

    describe 'when 5 days away' do
      before(:each) { allow(item).to receive(:sell_in).and_return(5) }

      it 'uses five_or_less quality' do
        expect(item).to receive(:quality=).with(5)
      end
    end

    describe 'when 10 days away' do
      before(:each) { allow(item).to receive(:sell_in).and_return(10) }

      it 'uses five_or_less quality' do
        expect(item).to receive(:quality=).with(10)
      end
    end
    
    describe 'when more than 10 days away' do
      before(:each) { allow(item).to receive(:sell_in).and_return(11) }

      it 'uses five_or_less quality' do
        expect(item).to receive(:quality=).with(3)
      end
    end
  end
end

describe ConjuredItem do
  include_examples 'default item'

  describe '#initialize (subclass)' do
    before(:each) { described_class.new(item, params, multiplier: 3) }

    describe 'when created' do
      it 'multiplies increment by multiplier' do
        expect(subject.params[:quality_incr]).to eq 6
      end
    end
  end
end
