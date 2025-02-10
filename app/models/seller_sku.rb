# == Schema Information
#
# Table name: seller_skus
#
#  id         :bigint           not null, primary key
#  sku_code   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_seller_skus_on_sku_code  (sku_code) UNIQUE
#
class SellerSku < ApplicationRecord
  has_many :order_lines
  has_many :sku_mappings

  validates :sku_code, presence: true, uniqueness: true
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id sku_code updated_at]
  end
end
