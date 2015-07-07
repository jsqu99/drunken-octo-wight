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
      adj = Invoice::TaxAdjustment.new(description: 'tax', amount: Money.new(100, 'USD'))
      @invoice.debits << adj
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

  context "#balance" do
    context "no payments made" do
      it "calculates the correct balance" do
        expect(@invoice.balance).to eq(Money.new(250, 'USD'))
      end
    end

    context "partial payment made" do
      it "calculates the correct balance" do
        allow(@invoice).to receive(:payments).
          and_return([
            Payment.new(amount_cents: 1, amount_currency: 'USD')])
        expect(@invoice.balance).to eq(Money.new(249, 'USD'))
      end
    end

    context "full payment made" do
      it "calculates the correct balance" do
        allow(@invoice).to receive(:payments).
          and_return([
            Payment.new(amount_cents: 250, amount_currency: 'USD')])
        expect(@invoice.balance).to eq(Money.new(0, 'USD'))
      end
    end
  end

  it "removes adjustments of a certain type" do
    adj = Invoice::TaxAdjustment.new(description: 'tax', amount: Money.new(100, 'USD'))
    @invoice.debits << adj
    adj_arr = [adj]
    allow(@invoice).to receive(:debits).and_return(adj_arr)

    # i feel so dirty...but no way i'm saving a giant object graph to test this
    Array.class_eval do
      def where(*) self end
      def destroy_all() end
    end

    expect_any_instance_of(Array).to receive(:destroy_all)
    @invoice.remove_adjustments_of_type("Invoice::TaxAdjustment")
  end
end
