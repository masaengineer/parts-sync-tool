require 'rails_helper'

RSpec.describe Shipment, type: :model do
  describe 'アソシエーション' do
    it { should belong_to(:order).optional }
  end

  describe 'ransackable_attributes' do
    subject { Shipment.ransackable_attributes }

    it { should include('tracking_number', 'customer_international_shipping', 'created_at', 'updated_at') }
  end

  describe '基本的な属性' do
    subject { build(:shipment) }

    it { should respond_to(:customer_international_shipping) }
    it { should respond_to(:tracking_number) }
    it { should respond_to(:cpass_trade_id) }

    describe '属性の型' do
      it { expect(subject.customer_international_shipping).to be_a_kind_of(Numeric) }
      it { expect(subject.cpass_trade_id).to be_a_kind_of(Integer) }
      it { expect(subject.tracking_number).to match(/\ATN\d{12}\z/) }
    end
  end
end
