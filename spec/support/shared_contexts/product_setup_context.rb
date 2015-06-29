RSpec.shared_context "product_setup" do
  let(:product1) { Product.new}
  let(:product2) { Product.new}

  let!(:product_price1) { product1.prices.build(price: price)}
  let!(:product_price2) { product2.prices.build(price: price)}

  let(:price) { Money.new(100, 'USD') }
end
