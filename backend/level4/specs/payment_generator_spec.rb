require './rental.rb'
require './car.rb'
require './payment_generator.rb'

shared_examples_for "a_generated_commission_method" do |party, action|
  subject { payment_generator.send "#{party}_#{action}".to_sym }
    
  it { is_expected.to eq(payment_generator.commission.value["#{party}_commission".to_sym]) }
end

RSpec.describe PaymentGenerator do
  let(:car) { Car.new(100, 200) }
  let(:rental) { Rental.new(car, '2018-4-14', '2018-4-15', 10) }
  let(:payment_generator) { PaymentGenerator.new(rental) }

  describe '#initialize' do
    subject { payment_generator }
    
    its(:rental) { is_expected.to eq(rental) }
    its(:commission) { is_expected.to eq(rental.commission) }
  end

  describe 'its methods' do
    subject { payment_generator }

    let(:expected_methods) { [:insurance_credit, :assistance_credit, :drivy_credit, :owner_credit, :driver_credit] }

    it 'has the expected methods' do
      expect(subject.methods & expected_methods).not_to be_nil
    end
  end

  describe '#payment_actions' do
    subject { payment_generator.payment_actions }
    
    it { is_expected.to be_a(Array) }
    it "the hash have the correct keys" do
      expect(subject.map(&:keys).uniq.flatten).to eq([:who, :type, :amount])
    end
  end

  describe '#driver_debit' do
    subject { payment_generator.driver_debit }

    it { is_expected.to eq(2190) }
  end

  describe '#owner_credit' do
    subject { payment_generator.owner_credit }

    it { is_expected.to eq(1533) }
  end

  describe '#insurance_credit' do
    it_behaves_like 'a_generated_commission_method', 'insurance', 'credit'
  end

  describe '#drivy_credit' do
    it_behaves_like 'a_generated_commission_method', 'drivy', 'credit'
  end

  describe '#assistance_credit' do
    it_behaves_like 'a_generated_commission_method', 'assistance', 'credit'
  end
end