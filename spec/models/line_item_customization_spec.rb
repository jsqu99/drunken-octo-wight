require 'spec_helper'
require 'support/shared_contexts/product_setup_context'

describe LineItemCustomization do
  include_context "product_setup"

  before do
    @line_item = LineItem.new(product: product1)
  end

  # a shipping address is a special customization as
  # it's presence affects whether or not we need to
  # separately collect an order-level shipping address
  context "#shipping_address?" do
    it "should know that it represents a shipping address" do
      customization = @line_item.customizations.build
      customization.customizable =  ShippingAddress.new(fake_string: 'foo')
      expect(customization.shipping_address?).to be_truthy
    end

    it "should know that it does not represent a shipping address" do
      customization = @line_item.customizations.build
      customization.customizable =  LineItem.new
      expect(customization.shipping_address?).to be_falsey
    end
  end
end
