require './car.rb'
require './rental.rb'
require './commission.rb'
RSpec.describe Commission do
  let(:car) { Car.new(100, 200) }
  let(:rental) { Rental.new(car, '2018-4-14', '2018-4-15', 10) }
  let(:commission) { Commission.new(rental) }

  describe '#initialize' do
    subject { commission }
    
    its(:price) { is_expected.to eq(rental.price) }
    its(:duration) { is_expected.to eq(rental.duration) }
    its(:total_commission) { is_expected.to eq(657) }
  end

  describe '#value' do
    subject { commission.value }
    
    it { is_expected.to be_a(Hash) }
    it "has 3 keys" do
      expect(subject.keys).to eq([:insurance_fee, :assistance_fee, :drivy_commission])  
    end
  end

  describe '#total_commission' do
    subject { commission.send :total_commission }
    
    context 'with a base (30%) TOTAL_COMMISSION' do
      it { is_expected.to eq(657) }
    end
  end

  describe '#insurance_fee' do
    subject { commission.send :insurance_fee }
    
    context 'takes 50% of the total commission' do
      it { is_expected.to eq(328) }
    end
  end

  describe '#roadside_assistance_fee' do
    subject { commission.send :roadside_assistance_fee }
    
    context 'with a 2 days trip' do
      it { is_expected.to eq(200) }
    end

    context 'with a 3 days trip' do
      let(:rental) { Rental.new(car, '2018-4-14', '2018-4-16', 10) }
      it { is_expected.to eq(300) }
    end
  end

  describe '#drivy_commission' do
    subject { commission.send :drivy_commission }
    it { is_expected.to eq(129) }
  end
end