require './car.rb'
require './rental.rb'
require './payment_generator.rb'
class RentalCalculator
  attr_reader :cars, :rentals, :options

  def initialize(cars, rentals, options)
    @cars = cars
    @rentals = rentals
    @options = options
  end

  def get_rental_prices
    cars = get_cars
    options = option_types_by_rental

    rentals.map do |requested_rental|
      rental_options = options[requested_rental['id']]
      rental = Rental.new(cars[requested_rental['car_id']],
                          requested_rental['start_date'],
                          requested_rental['end_date'],
                          requested_rental['distance'])

      payment_generator = PaymentGenerator.new(rental, rental_options)
      {
        id: requested_rental['id'],
        options: rental_options || [],
        actions: payment_generator.payment_actions
      }
    end
  end

  private
  def get_cars
    result = {}

    cars.each do |car|
      result[car['id']] = Car.new(car['price_per_day'], car['price_per_km'])
    end
    result
  end

  def option_types_by_rental
    result = {}

    options.each do |option|
      rental_id = option['rental_id']
      result[rental_id] ||= []
      result[rental_id] << option['type']
    end
    result
  end
end