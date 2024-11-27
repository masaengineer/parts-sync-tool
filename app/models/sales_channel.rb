class SalesChannel < ApplicationRecord
  has_many :orders
  has_many :sales_channel_fees

  validates :channel_name, presence: true
end
