require 'money'
require 'spec_helper'
require 'support/shared_contexts/product_setup_context'

describe LineItem do
  include_context "product_setup"

  before do
    @line_item = LineItem.new(product: product1)
  end

  it "starts with correct default attributes" do
    expect(@line_item.quantity).to eq(1)
  end

  it "supports persisting a new quantity" do
    @line_item.change_quantity 4
    expect(@line_item.reload.quantity).to eq(4)
  end

  it "destroys itself when setting quantity to zero" do
    cart = Cart.new(currency: 'USD')
    line_item = cart.add_product(product1)

    line_item.change_quantity 0
    expect(cart.line_items.size).to eq(0)
  end

  it "finds a line item in a collection for an id" do
    @line_item.save! # we need an id to test this
    expect(LineItem.for_id_from_collection(@line_item.id, [@line_item])).to eq(@line_item)
  end

  it "returns a NulLineItem in a collection for a non-existent id" do
    expect(LineItem.for_id_from_collection(1234, [@line_item]).class).to eq(NullLineItem)
  end

  context "#customizations" do
    context "#shipping_address" do
      before do
        @address = ShippingAddress.new(fake_string: 'foo')
        customization = @line_item.customizations.build
        customization.customizable =  @address
      end

      it "returns the shipping address from the customization" do
        expect(@line_item.shipping_address).to eq(@address)
      end

      it "knows it has it's own shipping address" do
        expect(@line_item.has_own_shipping_address?).to be_truthy
      end
    end

    context "#no shipping address" do
      it "returns the shipping address from the order" do
        cart = Cart.new(currency: 'USD')
        @line_item.cart = cart
        order = Order.new(cart: cart)
        expect(order).to receive(:shipping_address)
        @line_item.shipping_address
      end

      it "knows it does not have it's own shipping address" do
        expect(@line_item.has_own_shipping_address?).to be_falsey
      end
    end
  end
end

describe NullLineItem do
  before do
    @line_item = NullLineItem.new
  end

  it 'supports #change_quantity' do
    expect(@line_item.change_quantity(1)).to be_truthy
  end

  it 'supports #destroy' do
    expect(@line_item.destroy).to be_truthy
  end
end
