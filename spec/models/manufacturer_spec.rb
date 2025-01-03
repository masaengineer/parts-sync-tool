require 'rails_helper'

RSpec.describe Manufacturer, type: :model do
  describe 'バリデーション' do
    it { should be_valid }
  end

  describe 'アソシエーション' do
    it { should have_many(:skus) }
  end

  describe 'スコープとクエリ' do
    it { should have_db_index(:name) }
  end
end
