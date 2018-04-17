class Car
  attr_reader :price_per_day, :price_per_km

  def initialize(price_per_day, price_per_km)
    @price_per_day = price_per_day
    @price_per_km = price_per_km
  end
end