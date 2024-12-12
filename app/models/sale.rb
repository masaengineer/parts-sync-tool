# == Schema Information
#
# Table name: sales
#
#  id                 :bigint           not null, primary key
#  order_id           :bigint           not null
#  order_net_amount   :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  order_gross_amount :decimal(, )
#
# Indexes
#
#  index_sales_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
class Sale < ApplicationRecord
  belongs_to :order

  def self.ransackable_attributes(auth_object = nil)
    %w[
      created_at
      updated_at
      order_id
      order_net_amount
      order_gross_amount
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[order]
  end
end
