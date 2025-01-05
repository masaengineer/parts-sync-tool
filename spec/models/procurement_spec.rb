# == Schema Information
#
# Table name: procurements
#
#  id             :bigint           not null, primary key
#  purchase_price :decimal(, )
#  forwarding_fee :decimal(, )
#  photo_fee      :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  order_id       :bigint           not null
#  handling_fee   :decimal(10, 2)
#
# Indexes
#
#  index_procurements_on_order_id  (order_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
require 'rails_helper'

RSpec.describe Procurement, type: :model do
  describe 'バリデーション' do
    it { should validate_presence_of(:purchase_price) }
    it { should validate_presence_of(:order_id) }
  end

  describe 'アソシエーション' do
    it { should belong_to(:order) }
  end

  describe 'インデックス' do
    it { should have_db_index(:order_id).unique }
  end

  describe '#total_cost' do
    let(:procurement) { build(:procurement) }

    context '全ての費用が存在する場合' do
      subject { procurement.total_cost }
      let(:expected_total) do
        procurement.purchase_price +
        procurement.forwarding_fee +
        procurement.photo_fee +
        procurement.handling_fee
      end

      it { should eq(expected_total) }
    end

    context '一部の費用が存在しない場合' do
      subject { procurement.total_cost }
      before do
        procurement.forwarding_fee = nil
        procurement.photo_fee = nil
      end
      let(:expected_total) { procurement.purchase_price + procurement.handling_fee }

      it { should eq(expected_total) }
    end
  end

  describe '金額属性' do
    subject { build(:procurement) }

    it { should respond_to(:purchase_price) }
    it { should respond_to(:forwarding_fee) }
    it { should respond_to(:photo_fee) }
    it { should respond_to(:handling_fee) }

    it { expect(subject.purchase_price).to be_a_kind_of(Numeric) }
    it { expect(subject.forwarding_fee).to be_a_kind_of(Numeric) }
    it { expect(subject.photo_fee).to be_a_kind_of(Numeric) }
    it { expect(subject.handling_fee).to be_a_kind_of(Numeric) }
  end
end
