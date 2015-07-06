RSpec.shared_context "order_setup" do
  include_context "product_setup"

  before do
    @cart = Cart.new(currency: 'USD')
    @line_item = LineItem.new(product: product1, unit_price: Money.new(250, 'USD'))
    @cart.line_items << @line_item
    @order = Order.new(cart: @cart)
  end
end
