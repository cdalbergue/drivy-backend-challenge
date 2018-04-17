class PaymentGenerator
  DEBIT_TYPE = 'debit'
  CREDIT_TYPE = 'credit'
  SPECIFIC_ACTIONS = {
    driver: DEBIT_TYPE,
    owner: CREDIT_TYPE,
  }
  GENERIC_ACTIONS = {
    insurance: CREDIT_TYPE,
    assistance: CREDIT_TYPE,
    drivy: CREDIT_TYPE,
  }

  attr_reader :rental, :commission

  def initialize(rental)
    @rental = rental
    @commission = rental.commission
  end

  def payment_actions
    actions = SPECIFIC_ACTIONS.merge(GENERIC_ACTIONS)
    actions.map do |party, action|
      {
        'who': party.to_s,
        'type': action,
        'amount': __send__("#{party}_#{action}")
      }
    end
  end

  define_method("driver_#{SPECIFIC_ACTIONS[:driver]}") do
    rental.price
  end

  define_method("owner_#{SPECIFIC_ACTIONS[:owner]}") do
    (rental.price - commission.total_commission).to_i
  end

  %W(insurance assistance drivy).each do |party|
    define_method("#{party}_#{GENERIC_ACTIONS[party.to_sym]}") do
      commission.value["#{party}_commission".to_sym]
    end
  end
end