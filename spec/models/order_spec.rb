require 'money'
require 'spec_helper'
require 'support/shared_contexts/product_setup_context'

describe Order do
  include_context "order_setup"

  context "#has all 'shipment-aware' line items " do
    it "doesn't require a shipping address" do
      address = ShippingAddress.new(fake_string: 'foo')
      customization = @line_item.customizations.build
      customization.customizable =  address
      expect(@order.save!).to be_truthy
    end
  end

  context "#has one none-'shipment-aware' line item " do
    it "requires a shipping address" do
      expect{@order.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    # might refactor to not need this public method exposing state,
    # but for now, let's test it and stay at 100% code coverage!
    it "knows it is missing a shipping address" do
      expect(@order.missing_explicit_shipping_address?).to be_truthy
    end
  end
end
