require_relative '../models/invoice/shipping_adjustment'

class CreateShippingCharge
  def initialize(invoice)
    @invoice = invoice
  end

  def create(description, amount)
    @invoice.debits.create!(type: 'Invoice::ShippingAdjustment', description: description, amount: amount)
  end
end
