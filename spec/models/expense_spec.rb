require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe '基本的な属性' do
    subject { build(:expense) }

    it { should respond_to(:year) }
    it { should respond_to(:month) }
    it { should respond_to(:item_name) }
    it { should respond_to(:amount) }
  end

  describe '属性の型と範囲' do
    subject { build(:expense) }

    it { expect(subject.year).to be_a_kind_of(Integer) }
    it { expect(subject.month).to be_a_kind_of(Integer) }
    it { expect(subject.amount).to be_a_kind_of(Numeric) }

    # 将来的なバリデーション追加を想定したコメント
    # it { should validate_inclusion_of(:month).in_range(1..12) }
    # it { should validate_numericality_of(:amount).is_greater_than(0) }
  end
end
