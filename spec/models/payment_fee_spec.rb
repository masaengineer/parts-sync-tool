# == Schema Information
#
# Table name: payment_fees
#
#  id           :bigint           not null, primary key
#  order_id     :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  fee_category :string
#  fee_amount   :decimal(, )
#
# Indexes
#
#  index_payment_fees_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
require 'rails_helper'

RSpec.describe PaymentFee, type: :model do
  describe 'バリデーション' do
    it { should validate_presence_of(:fee_amount) }
    it { should validate_presence_of(:fee_category) }
    it { should validate_numericality_of(:fee_amount) }
  end

  describe 'アソシエーション' do
    it { should belong_to(:order) }
  end

  describe 'スコープ' do
    let!(:credit_card_fee) { create(:payment_fee, fee_category: 'クレジットカード手数料') }
    let!(:bank_transfer_fee) { create(:payment_fee, fee_category: '銀行振込手数料') }

    describe '.by_category' do
      subject { PaymentFee.by_category('クレジットカード手数料') }

      it { should include(credit_card_fee) }
      it { should_not include(bank_transfer_fee) }
    end
  end
end
