class Order < ApplicationRecord
  belongs_to :channel
  belongs_to :user
  belongs_to :buyer
end
