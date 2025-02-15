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

class Order < ApplicationRecord
  belongs_to :user
  has_many :order_lines, dependent: :destroy
  has_many :payment_fees, dependent: :destroy
  has_one :procurement, dependent: :destroy
  has_many :sales
  has_one :shipment

  validates :order_number, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    %w[
      order_number
      sale_date
      created_at
      updated_at
      user_id
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user sale order_lines skus procurement shipment payment_fees]
  end

  # 注文に関連する仕入れコストの合計を計算
  def total_procurement_cost
    procurement&.total_cost || 0
  end
end
