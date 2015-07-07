require_relative '../models/payment'
require_relative '../models/credit_card'

##
# This class is responsible for storing evidence of a payment into the order invoice
#

class StoreCreditCardPaymentReceipt
  def initialize(invoice)
    @invoice = invoice
  end

  def store(credit_card, amount, transaction_id)
    @invoice.payments.create!(source: credit_card, amount: amount, transaction_id: transaction_id)
  end
end
