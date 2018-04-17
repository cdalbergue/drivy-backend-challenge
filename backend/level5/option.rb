class Option
  AVAILABLE_OPTIONS = {
    gps: { cost: 500, to_party: 'owner' },
    baby_seat: { cost: 200, to_party: 'owner' },
    additional_insurance: { cost: 1000, to_party: 'drivy' },
  }

  attr_reader :price, :to_party
  def initialize(option_type)
    @price = AVAILABLE_OPTIONS[option_type.to_sym][:cost]
    @to_party = AVAILABLE_OPTIONS[option_type.to_sym][:to_party]
  end

  def self.format_for_parties(options)
    result = {}
    options.each do |option|
      party = option.to_party
      result[party] ||= 0
      result[party] += option.price
    end
    result
  end
end