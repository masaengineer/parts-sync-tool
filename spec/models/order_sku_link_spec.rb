# == Schema Information
#
# Table name: order_sku_links
#
#  id         :bigint           not null, primary key
#  order_id   :bigint           not null
#  sku_id     :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_order_sku_links_on_order_id             (order_id)
#  index_order_sku_links_on_order_id_and_sku_id  (order_id,sku_id) UNIQUE
#  index_order_sku_links_on_sku_id               (sku_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (sku_id => skus.id)
#
require 'rails_helper'

RSpec.describe OrderSkuLink, type: :model do
  describe 'バリデーション' do
    subject { build(:order_sku_link) }

    context '有効なデータの場合' do
      it 'orderとskuがある場合は有効である' do
        expect(subject).to be_valid
      end
    end
  end

  describe 'アソシエーション' do
    it { should belong_to(:order) }
    it { should belong_to(:sku) }
  end

  describe 'インデックス' do
    it { should have_db_index([ :order_id, :sku_id ]).unique }
  end

  describe 'ransackable_attributes' do
    subject { OrderSkuLink.ransackable_attributes }

    it { should include('created_at', 'updated_at', 'order_id', 'sku_id') }
  end

  describe 'ransackable_associations' do
    subject { OrderSkuLink.ransackable_associations }

    it { should include('order', 'sku') }
  end
end
