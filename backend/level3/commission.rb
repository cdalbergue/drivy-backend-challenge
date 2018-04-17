class Commission
  TOTAL_COMMISSION = 0.3
  INSURANCE_FEE = 0.5
  ROADSIDE_ASSISTANCE_FEE = 100

  attr_reader :price, :duration, :total_commission

  def initialize(rental)
    @price = rental.price
    @duration = rental.duration
    @total_commission = total_commission
  end

  def value
    {
      insurance_fee: insurance_fee,
      assistance_fee: roadside_assistance_fee,
      drivy_commission: drivy_commission
    }
  end

  private
  def total_commission
    (price * TOTAL_COMMISSION).to_i
  end

  def insurance_fee
    (total_commission * INSURANCE_FEE).to_i
  end

  def roadside_assistance_fee
    (duration * ROADSIDE_ASSISTANCE_FEE).to_i
  end

  def drivy_commission
    (total_commission - insurance_fee - roadside_assistance_fee).to_i
  end
end