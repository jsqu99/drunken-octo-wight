require 'money'
require 'spec_helper'

describe "CreateShippingCharge" do
  before do
    @invoice = Invoice.create(order_id: 1234)
  end

  it "creates a shipping charge" do
    service = CreateShippingCharge.new(@invoice)
    desc = 'shipping charge - fedex'
    service.create(desc, Money.new(123, 'EUR'))
    expect(@invoice.debits.first.description).to eq(desc)
  end
end
