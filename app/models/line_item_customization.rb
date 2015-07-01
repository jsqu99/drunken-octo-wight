class LineItemCustomization < ActiveRecord::Base
  belongs_to :line_item
  belongs_to :customizable, polymorphic: true

  # we'll use this to determine whether or not our checkout flow
  # needs to collect a shipping address
  def shipping_address?
    customizable_type == "ShippingAddress"
  end

  def shipping_address
    customizable if shipping_address?
  end
end
