class InvoiceAdjustment < ActiveRecord::Base
  belongs_to :invoice

  validates :description, presence: true
  monetize :amount, null: false

  def amount
    Money.new amount_cents, amount_currency
  end

  def amount=(value)
    value = Money.parse(value) if value.instance_of? String  # otherwise assume, that value is a Money object

    write_attribute :amount_cents,    value.cents
    write_attribute :amount_currency, value.currency_as_string
  end

end
