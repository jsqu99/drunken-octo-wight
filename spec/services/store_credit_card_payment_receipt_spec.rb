require 'money'
require 'spec_helper'
require_relative '../../app/services/store_credit_card_payment_receipt'
require_relative '../../app/models/credit_card'

describe "StoreCreditCardPaymentReceipt" do
  before do
    @invoice = Invoice.create(order_id: 1234)
  end

  it "creates a shipping charge" do
    service = StoreCreditCardPaymentReceipt.new(@invoice)
    credit_card = CreditCard.new(month: '1', year: '2016',
                                 number: '4111222233334444',
                                 name_on_card: 'Jacko Lantern',
                                 verification_value: '123',
                                 billing_address_id: 1)
    service.store(credit_card, Money.new(123, 'EUR'), '1234')
    expect(@invoice.payments.first.transaction_id).to eq('1234')
  end
end
