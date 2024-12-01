class StorageLocation < ApplicationRecord
  include Addressable
  include Contactable

  belongs_to :wholesaler, optional: true
  has_many :inventory_locations
  has_many :inventories, through: :inventory_locations

  validates :name, presence: true
  validates :location_type, presence: true
  validate :validate_location_type_requirements

  enum location_type: {
    company_warehouse: 'company_warehouse',
    wholesaler_warehouse: 'wholesaler_warehouse'
  }

  private

  def validate_location_type_requirements
    if wholesaler_warehouse?
      errors.add(:wholesaler, "must be present for wholesaler warehouse") if wholesaler.nil?
    end
  end
end
