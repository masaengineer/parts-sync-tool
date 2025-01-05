# == Schema Information
#
# Table name: manufacturers
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_manufacturers_on_name  (name)
#
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
