class Order < ActiveRecord::Base
  belongs_to :cart
  has_one :shipping_address #optional - if we only have subscription line items, each line item will have it's own shipping address
  has_one :invoice
  delegate :line_items, :currency, to: :cart
  validates :cart, presence: true
  validates :shipping_address, presence: true, if: :requires_explicit_shipping_address?

  def missing_explicit_shipping_address?
    requires_explicit_shipping_address? && !shipping_address.present?
  end

  private
    def requires_explicit_shipping_address?
      line_items.any? { |li| !li.has_own_shipping_address? }
    end
end
