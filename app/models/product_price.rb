class ProductPrice < ActiveRecord::Base
  belongs_to :product
  monetize :price

  def price
    Money.new price_cents, price_currency
  end

  def price=(value)
    value = Money.parse(value) if value.instance_of? String  # otherwise assume, that value is a Money object

    write_attribute :price_cents,    value.cents
    write_attribute :price_currency, value.currency_as_string
  end
end
