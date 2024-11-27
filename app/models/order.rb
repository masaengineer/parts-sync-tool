class Order < ApplicationRecord
  belongs_to :sales_channel, class_name: 'SalesChannel'
  belongs_to :user
  belongs_to :buyer

  has_many :order_items
  has_many :order_status_histories
  has_many :remarks
  has_many :shipments
  has_many :procurements
  has_many :sales
  has_many :payment_fees
  has_many :advertising_costs

  validates :order_number, presence: true, uniqueness: true
  validates :order_status, presence: true
end
