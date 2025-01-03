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
    it { should have_db_index([:order_id, :sku_id]).unique }
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
