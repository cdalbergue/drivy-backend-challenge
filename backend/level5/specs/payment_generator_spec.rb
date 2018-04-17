require './rental.rb'
require './car.rb'
require './option.rb'
require './payment_generator.rb'

shared_examples_for "a_generated_commission_method" do |party, action|
  subject { payment_generator.send "#{party}_#{action}".to_sym }
    
  it { is_expected.to eq(payment_generator.commission.value["#{party}_commission".to_sym]) }
end

RSpec.describe PaymentGenerator do
  let(:car) { Car.new(100, 200) }
  let(:rental) { Rental.new(car, '2018-4-14', '2018-4-15', 10) }
  let(:options) { ['gps'] }
  let!(:payment_generator) { PaymentGenerator.new(rental, options) }

  describe '#initialize' do
    subject { payment_generator }
    
    its(:rental) { is_expected.to eq(rental) }
    its(:commission) { is_expected.to eq(rental.commission) }
    its(:options) { is_expected.to be_a(Array) }

    it 'options contains option classes' do
      expect(subject.options.first).to be_instance_of(Option)
    end
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

  describe '#optionify' do
    subject { payment_generator.send(:optionify, ['gps']) }
    

    it { is_expected.to be_a(Array) }
    it 'creates an option instance of type gps' do
      expect(Option).to receive(:new).with('gps')
      subject
    end
    it 'contains Option classes' do
      expect(subject.first).to be_instance_of(Option)
    end
  end

  describe '#extra_for' do
    context 'with someone that gets an extra' do
      subject { payment_generator.send(:extra_for, 'owner') }
      it { is_expected.to eq(1000) }
    end

    context 'with someone that does not get an extra' do
      subject { payment_generator.send(:extra_for, 'driver') }
      it { is_expected.to eq(0) }
    end
  end

  describe '#driver_debit' do
    subject { payment_generator.send :driver_debit }

    it { is_expected.to eq(3190) }
  end

  describe '#owner_credit' do
    subject { payment_generator.send :owner_credit }

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