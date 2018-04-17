require 'rspec/its'
require 'json'
require './car.rb'
require './rental.rb'
require './rental_calculator.rb'
RSpec.describe RentalCalculator do
  let(:rentals_hash) { [{'id' => 1, 'car_id' => 1, 'start_date' => '2018-4-14', 'end_date' => '2018-4-15', 'distance' => 10},
                        {'id' => 2, 'car_id' => 2, 'start_date' => '2018-4-16', 'end_date' => '2018-4-18', 'distance' => 10}] }
  let(:cars_hash) { [{ 'id' => 1, 'price_per_day' => 10, 'price_per_km' => 20 },
                     { 'id' => 2, 'price_per_day' => 20, 'price_per_km' => 30 }] }

  subject { RentalCalculator.new(cars_hash, rentals_hash) }

  describe '#initialize' do
    its(:cars) { is_expected.to eq(cars_hash) }
    its(:rentals) { is_expected.to eq(rentals_hash) }
  end

  describe '#get_cars' do
    subject { super().send :get_cars }

    its(:count) { is_expected.to eq(2) }
    it 'contains cars' do
      expect(subject.first[1]).to be_instance_of(Car)
    end
  end

  describe '#get_rental_prices' do
    subject { super().get_rental_prices }

    it { is_expected.to be_a(Array) }
    its(:size) { is_expected.to eq(2) }
    
    it "has id, price and commission keys for each object" do
      expect(subject().first.keys).to eq([:id, :price, :commission])
    end
  end
end