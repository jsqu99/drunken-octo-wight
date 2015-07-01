require 'spec_helper'
require 'support/shared_contexts/product_setup_context'
require 'ostruct'

def line_items_equal?(s,d)
  line_items_same_size?(s, d) && line_items_same_contents?(s,d)
end

def line_items_same_size?(s,d)
  s.size == d.size
end

def line_items_same_contents?(s,d)
  products_quantities_from_line_items(s).all? { |pq|
    products_quantities_from_line_items(d).include?(pq)
  }
end

def products_quantities_from_line_items(lis)
  lis.map { |li| [li.product, li.quantity]}
end


describe Cart do
  include_context "product_setup"

  before do
    @cart = Cart.new(currency: 'USD')
  end

  it "is empty when created" do
    expect(@cart.empty?).to be_truthy
  end

  describe "#add_product" do
    it "returns a new line_item" do
      expect(@cart.add_product(product1).product).to eq(product1)
    end

    describe "product exists in cart" do
      before do
        @cart.add_product(product1)
      end

      it "correctly updates the quantity by adding the new amount" do
        expect(@cart.add_product(product1,4).quantity).to eq(5)
      end
    end

    describe "product doesn't yet exist in cart" do
      it "correctly updates the quantity by using the new amount" do
        expect(@cart.add_product(product1,4).quantity).to eq(4)
      end
    end
  end

  describe "#update_items" do
    before do
      @line_item = @cart.add_product(product1)
      @cart.save!
    end

    it "updates the items in the cart" do
      expect{
        @cart.update_items(Array[[@line_item.id, 4]])
      }.to change{@line_item.quantity}.from(1).to(4)
    end

    it "removes a line_item with quantity 0" do
      expect{
        @cart.update_items(Array[[@line_item.id, 0]])
      }.to change{@cart.line_items.size}.from(1).to(0)
    end
  end

  describe "#remove_item" do
    it "removes an item" do
      item = @cart.add_product(product1)
      @cart.remove_item(item)
      expect(@cart.matching_line_item(product1)).to be_nil
    end
  end

  describe "#matching_line_item" do
    context "#when a match exists" do
      it "finds a match" do
        @cart.add_product(product1)
        expect(@cart.matching_line_item(product1)).to eq(@cart.line_items.first)
      end
    end

    context "#when a match does not exist" do
      it "doesn't find a match when the product isn't already in the cart" do
        expect(@cart.matching_line_item(product1)).to be_nil
      end

      it "doesn't find a match when the price differs" do
        li = @cart.add_product(product1)
        # I'll revisit this when I take a closer look at initializing the line item based on product price wrt to currency
        li.unit_price = Money.new(123)
        li.save!
        expect(@cart.matching_line_item(product1)).to be_nil
      end
    end
  end

  describe "#emptying the cart" do
    describe "#when cart already empty" do
      it "leaves the cart unchanged" do
        @cart.empty
        expect(@cart.line_items.size).to eq(0)
      end
    end

    describe "#when cart not empty" do
      it "completely empties the cart" do
        @cart.empty
        expect(@cart.line_items.size).to eq(0)
      end
    end
  end

  describe "#updating the currency of the cart" do
    before do
      @cart.add_product(product1)
      @cart.update_currency('EUR')
    end

    it "empties the cart" do
      expect(@cart.empty?).to be_truthy
    end

    it "changes the currency" do
      expect(@cart.currency).to eq('EUR')
    end
  end
end
