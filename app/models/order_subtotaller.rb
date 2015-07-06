class OrderSubtotaller
  def initialize(order)
    @order = order
  end

  def subtotal
    t = @order.line_items.map {|li|
      li.quantity * li.unit_price
    }.sum

    Money.new t, @order.currency
  end
end
