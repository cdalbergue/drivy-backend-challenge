require './option.rb'
RSpec.describe Option do
  let(:option) { Option.new('gps') }
  
  describe '#initialize' do
    subject { option }
    
    its(:price) { is_expected.to eq(500) }
    its(:to_party) { is_expected.to eq('owner') }
  end

  describe '#format_for_parties' do
    subject { Option.format_for_parties([option]) }

    it { is_expected.to be_a(Hash) }
    it 'has the parties keys for the option' do
      expect(subject.keys).to eq(['owner'])
    end
    it 'has the good price for the option' do
      expect(subject['owner']).to eq(500)
    end

    context 'with multiple options' do
      let(:options) { [Option.new('gps'), Option.new('baby_seat'), Option.new('additional_insurance')] }
      
      subject { Option.format_for_parties(options) }

      it 'has the parties keys for the option' do
        expect(subject.keys).to eq(['owner', 'drivy'])
      end

      it 'has the good price for the owner' do
        expect(subject['owner']).to eq(700)
      end

      it 'has the good price for drivy' do
        expect(subject['drivy']).to eq(1000)
      end
    end
  end
end