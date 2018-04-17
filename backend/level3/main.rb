require './rental_calculator.rb'
require 'json'
class Runner
  def initialize(input_file)
    data = JSON.parse(File.read(input_file))
    @cars = data['cars']
    @rentals = data['rentals']
  end

  def output_to_file(path)
    rental_calculator = RentalCalculator.new(@cars, @rentals)
    output_data = {
      rentals: rental_calculator.get_rental_prices
    }
    File.open(path, 'w') do |file|
      file.write(JSON.pretty_generate(output_data))
    end
  end
end

Runner.new('data/input.json').output_to_file('data/output.json')