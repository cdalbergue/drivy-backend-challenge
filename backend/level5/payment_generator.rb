require './option.rb'
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
    drivy: CREDIT_TYPE
  }

  attr_reader :rental, :commission, :options

  def initialize(rental, option_types=[])
    @rental = rental
    @commission = rental.commission
    @options = optionify(option_types)
  end

  def payment_actions
    actions = SPECIFIC_ACTIONS.merge(GENERIC_ACTIONS)
    actions.map do |party, action|
      amount = __send__("#{party}_#{action}") + extra_for(party)
      {
        who: party.to_s,
        type: action,
        amount: amount
      }
    end
  end

  private
  define_method("driver_#{SPECIFIC_ACTIONS[:driver]}") do
    rental.price + options.sum(&:price) * rental.duration
  end

  define_method("owner_#{SPECIFIC_ACTIONS[:owner]}") do
    (rental.price - commission.total_commission).to_i
  end

  %w(insurance assistance drivy).each do |party|
    define_method("#{party}_#{GENERIC_ACTIONS[party.to_sym]}") do
      commission.value["#{party}_commission".to_sym]
    end
  end

  def optionify(option_types)
    return [] unless option_types
    option_types.map do |option_type|
      Option.new(option_type)
    end
  end

  def extra_for(party)
    @extra_for ||= Option.format_for_parties(options)
    (@extra_for[party.to_s] || 0) * rental.duration
  end
end