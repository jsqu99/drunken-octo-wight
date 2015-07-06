class Invoice < ActiveRecord::Base
  belongs_to :order
  has_many :order_adjustments # tax, promo, shipping, etc.

  monetize :total

  def calculate_total
    OrderSubtotaller.new(order).subtotal + order_adjustments.map {|adj| adj.amount}.sum
  end

  def total
    Money.new total_cents, total_currency
  end

  def total=(value)
    value = Money.parse(value) if value.instance_of? String  # otherwise assume, that value is a Money object

    write_attribute :total_cents,    value.cents
    write_attribute :total_currency, value.currency_as_string
  end
end
