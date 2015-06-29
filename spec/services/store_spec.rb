require 'spec_helper'
require_relative '../../app/services/store_visit'
require 'support/shared_contexts/product_setup_context'

describe "Shopping Cart Actions" do
  include_context "product_setup"

  before do
    @cart = Cart.new(currency: 'USD')
  end

  describe FindCartForUser do
    pending "find cart for user"
  end

  describe UpdateItemsInCart do
    it "updates multiple items" do
      AddProductToCart.new(@cart).add(product1)

      line_item_quantities = [[@cart.line_items.first.id,3]]

      UpdateItemsInCart.new(@cart).update_items(line_item_quantities)
      expect(@cart.line_items.first.quantity).to eq(3)
    end
  end

  describe EmptyCart do
    it "empties the cart" do
      line_items = []
      2.times do
        line_items << LineItem.new
      end

      EmptyCart.new(@cart).empty
      expect(@cart.line_items).to be_empty
    end
  end

  describe AddProductToCart do
    it "adds to the cart" do
      AddProductToCart.new(@cart).add(product1)
      expect(@cart.line_items.first.product).to eq(product1)
    end
    it "adds to the cart with the correct quantity" do
      AddProductToCart.new(@cart).add(product1,5)
      expect(@cart.line_items.first.quantity).to eq(5)
    end
  end

  describe RemoveProductFromCart do
    it "removes product from the cart" do
      AddProductToCart.new(@cart).add(product1)
      expect(@cart.line_items.first.product).to eq(product1)
      RemoveProductFromCart.new(@cart).remove(product1)
    end

    it "does nothing when the product isn't in the cart" do
      AddProductToCart.new(@cart).add(product1,5)
      expect(@cart.line_items.first.quantity).to eq(5)
    end
  end

  describe RemoveItemFromCart do
    it "removes item from the cart" do
      AddProductToCart.new(@cart).add(product1)
      line_item = @cart.line_items.first

      finder = FindItemInCart.new(@cart)
      RemoveItemFromCart.new(@cart).remove(line_item)
      expect(finder.find(product1).class).to eq(NullLineItem)
    end
  end

  describe ChangeQuantityOfProductInCart do
    it "changes quantity" do
      line_item = AddProductToCart.new(@cart).add(product1)
      ChangeQuantityOfProductInCart.new(@cart).change_quantity(product1, 44)
      expect(line_item.quantity).to eq(44)
    end
  end

  describe ProductPriceForCurrency do
    it "finds the price" do
      expect(ProductPriceForCurrency.new(product1).find('USD')).to eq(Money.new(100,'USD'))
    end

    it "raises an error if it the price is missing" do
      expect{ProductPriceForCurrency.new(product1).find('EUR')}.to raise_error(MissingCurrencyForProductError)
    end
  end

  describe CartCurrencyUpdater do
    it "adds product to cart" do
      CartCurrencyUpdater.new(@cart).update('EUR')
      expect(@cart.currency).to eq('EUR')
    end
  end
end
