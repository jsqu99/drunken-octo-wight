class Invoice < ActiveRecord::Base
  belongs_to :order
  has_many :debits, class_name: 'DebitAdjustment' # tax, shipping
  has_many :credits, class_name: 'CreditAdjustment'# promo, store credits
  has_many :payments

  monetize :total

  # e.g. remove shipping costs b/c we have changed the shipping method
  # remove taxes b/c we have changed the shipping address
  def remove_adjustments_of_type(type)
    # i don't love this.  i had a has_many :adjustments but i removed it
    # b/c i didn't want to trip anyone up. The problem is, since I have
    # ill-advisedly? used multi-level inheritance, if you use the mid-level
    # adjustments association to add, say, a TaxAdjustment, the class
    # name isn't correct in the 'type' column in the db
    # so i'm making two db calls here, not one, which again, I don't love
    debits.where(type: type).destroy_all
    credits.where(type: type).destroy_all
  end

  def calculate_total
    OrderSubtotaller.new(self.order).subtotal + debit_total - credit_total
  end

  def balance
    calculate_total - payment_total
  end

  # what's the correct accounting term here?
  def finalize
    # set the total
  end

  def total
    Money.new total_cents, total_currency
  end

  def total=(value)
    value = Money.parse(value) if value.instance_of? String  # otherwise assume, that value is a Money object

    write_attribute :total_cents,    value.cents
    write_attribute :total_currency, value.currency_as_string
  end

  private
    def debit_total
      debits.map {|adj| adj.amount}.sum
    end

    def credit_total
      credits.map {|adj| adj.amount}.sum
    end

  # TODO: safeguard against multiple currencies
  # sample error: Money::Bank::UnknownRate: No conversion rate known for 'EUR' -> 'USD'
  def payment_total
    payments.map(&:amount).sum
  end
end
