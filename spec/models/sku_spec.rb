require 'rails_helper'

RSpec.describe Sku, type: :model do
  describe 'バリデーション' do
    subject { build(:sku) }

    it { should validate_presence_of(:sku_code) }
    it { should validate_uniqueness_of(:sku_code) }
  end

  describe 'アソシエーション' do
    it { should have_many(:order_sku_links) }
    it { should have_many(:orders).through(:order_sku_links) }
    it { should have_many(:procurements).through(:orders) }
    it { should belong_to(:manufacturer) }
  end

  describe 'ransackable_attributes' do
    subject { Sku.ransackable_attributes }

    it { should include('sku_code', 'quantity', 'sku_net_amount', 'sku_gross_amount', 'created_at', 'updated_at') }
  end

  describe 'ransackable_associations' do
    subject { Sku.ransackable_associations }

    it { should include('order_sku_links', 'orders', 'manufacturer') }
  end
end
