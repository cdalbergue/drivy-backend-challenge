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
    (distance_fee + duration_fee).to_i
  end

  private
  def distance_fee
    distance * car.price_per_km
  end

  def duration_fee
    fee = 0

    duration.times do |current_day|
      fee += car.price_per_day * discount_for_day(current_day)
    end
    fee
  end

  def duration
    duration = 1 + (Date.parse(end_date) - Date.parse(start_date)).to_i
    raise "Date cannot end before start" if duration <= 0
    duration
  end

  def discount_for_day(day)
    if day == 0
      1
    elsif day >= 1 && day < 4
      0.9
    elsif day >= 4 && day < 10
      0.7
    else
      0.5
    end
  end
end