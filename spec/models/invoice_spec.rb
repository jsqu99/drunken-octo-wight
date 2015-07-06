require 'money'
require 'spec_helper'
require 'support/shared_contexts/product_setup_context'

describe Invoice do
  include_context "order_setup"

  before do
    @invoice = Invoice.new(order: @order)
  end

  context "has adjustments" do
    it "computes the correct total" do
      adj = OrderAdjustment.new(description: 'tax', amount: Money.new(100, 'USD'))
      @invoice.order_adjustments << adj
      expect(@invoice.calculate_total).to eq(Money.new(350, 'USD'))
    end
  end

  context "has no adjustments" do
    it "computes the correct total" do
      expect(@invoice.calculate_total).to eq(Money.new(250, 'USD'))
    end
  end

  it "can read and write the total" do
    @invoice.total= Money.new(1,'USD')
    expect(@invoice.total).to eq(Money.new(1,'USD'))
  end
end
