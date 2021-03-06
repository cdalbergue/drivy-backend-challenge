require './car.rb'
require './rental.rb'
class RentalCalculator
  attr_reader :cars, :rentals

  def initialize(cars, rentals)
    @cars = cars
    @rentals = rentals
  end

  def get_rental_prices
    cars = get_cars
    rentals.map do |requested_rental|
      rental = Rental.new(cars[requested_rental['car_id']],
                          requested_rental['start_date'],
                          requested_rental['end_date'],
                          requested_rental['distance'])
      {
        id: requested_rental['id'],
        price: rental.price
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
end