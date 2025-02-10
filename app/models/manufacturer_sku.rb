class ManufacturerSku < ApplicationRecord
  belongs_to :manufacturer, index: true
end
