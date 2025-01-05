# == Schema Information
#
# Table name: orders
#
#  id           :bigint           not null, primary key
#  order_number :string
#  sale_date    :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_orders_on_order_number  (order_number)
#  index_orders_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'バリデーション' do
    subject { build(:order) }

    it { should validate_presence_of(:order_number) }
    it { should validate_uniqueness_of(:order_number) }
  end

  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should have_many(:order_sku_links).dependent(:destroy) }
    it { should have_many(:skus).through(:order_sku_links) }
    it { should have_many(:payment_fees).dependent(:destroy) }
    it { should have_one(:procurement).dependent(:destroy) }
    it { should have_one(:sale) }
    it { should have_one(:shipment) }
  end

  describe '#total_procurement_cost' do
    context '仕入れが存在する場合' do
      let(:order) { create(:order, :with_procurement) }
      before { allow(order.procurement).to receive(:total_cost).and_return(1000) }

      it { expect(order.total_procurement_cost).to eq(1000) }
    end

    context '仕入れが存在しない場合' do
      let(:order) { build(:order) }

      it { expect(order.total_procurement_cost).to eq(0) }
    end
  end
end
