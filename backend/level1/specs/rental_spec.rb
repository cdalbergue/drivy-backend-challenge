require './car.rb'
require './rental.rb'
require 'date'
RSpec.describe Rental do
  let(:car) { Car.new(100, 200) }
  let(:rental) { Rental.new(car, '2018-4-14', '2018-4-15', 10) }

  describe '#initialize' do
    subject { rental }
    its(:car) { is_expected.to eq(car) }
    its(:start_date) { is_expected.to eq('2018-4-14') }
    its(:end_date) { is_expected.to eq('2018-4-15') }
    its(:distance) { is_expected.to eq(10) }
  end

  describe '#price' do
    subject { rental.price }
    it { is_expected.to eq(2200) }
  end

  describe '#distance_fee' do
    subject { rental.send :distance_fee }
    it { is_expected.to eq(200 * 10) }
  end

  describe '#duration_fee' do
    subject { rental.send :duration_fee }
    it { is_expected.to eq(2*100) }
  end

  describe '#duration' do
    subject { rental.send :duration }
    it { is_expected.to eq(2) }

    context 'with a wrong date' do
      let(:rental) { Rental.new(car, '2018-13-32', '2018-4-15', 10) }
      it 'should raise' do
        expect{rental.send :duration}.to raise_error(ArgumentError)
      end
    end

    context 'when the rent starts after the end_date' do
      let(:rental) { Rental.new(car, '2018-4-16', '2018-4-15', 10) }
      it 'should raise' do
        expect{rental.send :duration}.to raise_error(RuntimeError)
      end
    end
  end
end