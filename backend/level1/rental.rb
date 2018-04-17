require 'date'
class Rental
  attr_reader :car, :start_date, :end_date, :distance
  
  def initialize(car, start_date, end_date, distance)
    @car = car
    @start_date = start_date
    @end_date = end_date
    @distance = distance
  end

  def price
    distance_fee + duration_fee
  end

  private
  def distance_fee
    distance * car.price_per_km
  end

  def duration_fee
    duration * car.price_per_day
  end

  def duration
    duration = 1 + (Date.parse(end_date) - Date.parse(start_date)).to_i
    raise "Date cannot end before start" if duration <= 0
    duration
  end
end