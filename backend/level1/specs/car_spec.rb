require './car.rb'
require 'rspec/its'
RSpec.describe Car do
  describe '#initialize' do
    subject { Car.new(12, 42) }
    its(:price_per_day) { is_expected.to eq(12) }
    its(:price_per_km) { is_expected.to eq(42) }
  end
end