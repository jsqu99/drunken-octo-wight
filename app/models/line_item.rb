require 'money'

class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  has_many :customizations, class_name: "LineItemCustomization"
  delegate :order, to: :cart
  monetize :unit_price

  def initialize(params={})
    super
    self.quantity= 1 unless params[:quantity]
  end

  def change_quantity(new_quantity)
    self.quantity = new_quantity
    destroy_if_empty || save!
  end

  def unit_price
    Money.new unit_price_cents, unit_price_currency
  end

  def unit_price=(value)
    value = Money.parse(value) if value.instance_of? String  # otherwise assume, that value is a Money object

    write_attribute :unit_price_cents,    value.cents
    write_attribute :unit_price_currency, value.currency_as_string
  end

  # If our item is something like a subscription with an embedded address, use that,
  # otherwise use the order-level shipping address
  def shipping_address
    source = shipping_address_customization || order
    source.shipping_address
  end

  def has_own_shipping_address?
    shipping_address_customization.present?
  end

  def self.for_id_from_collection(id, items)
    items.detect {|li| li.id == id} || NullLineItem.new
  end

  private
    def shipping_address_customization
      customizations.detect {
       |cust| cust.shipping_address?
      }
    end

    def destroy_if_empty
      cart.line_items.destroy(self) and return true if self.quantity <= 0
      false
    end
end


class NullLineItem
  def change_quantity(quantity)
    true
  end

  def destroy
    true
  end
end
