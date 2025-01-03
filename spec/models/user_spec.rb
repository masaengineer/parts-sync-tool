require 'rails_helper'

RSpec.describe User, type: :model do
  # FactoryBotを使用したテストデータの作成
  let(:user) { build(:user) }

  # バリデーションのテスト
  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).not_to be_valid
    end
  end

  # アソシエーションのテスト
  describe 'associations' do
    # アソシエーションがある場合は追加してください
  end
end
