class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  belongs_to :user
  has_one :order

  def add_product(product, quantity=1)
    line_item = matching_line_item(product) ||
                new_line_item(product)
    line_item.unit_price = product.price_in_currency(self.currency)
    line_item.quantity = line_item.quantity + quantity
    line_item
  end

  def update_items(line_item_quantities)
    line_item_quantities.each do |liq|
      li_id, quantity = liq[0], liq[1]

      # Ensure inbound line item id comes from my cart
      li = LineItem.for_id_from_collection(li_id, self.line_items)
      li.change_quantity(quantity)
    end
  end

  def matching_line_item(product)
    line_items.detect { |li|
      li.product == product &&
      li.unit_price == product.price_in_currency(self.currency)
    }
  end

  def remove_item(line_item)
    line_items.destroy line_item
  end

  def empty
    line_items.destroy_all
  end

  def empty?
    line_items.size == 0
  end

  def update_currency(new_currency)
    if self.currency != new_currency
      # FUTURE:
      # the right thing to do would be to take the amount
      # in the cart (not from the current value in product)
      # and convert that.
      empty
      update_attributes(currency: new_currency)
    end
  end

  private
    def new_line_item(product)
      line_items.build.tap do |li|
        # we'll be overwriting by adding passed-in param (which defaults to 1)
        li.quantity = 0
        li.product = product
      end
    end
end
