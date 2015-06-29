# this will be in a controller before_filter to init a StoreVisit
class StoreVisit
  attr_accessor :currency
  def initialize(currency, user = nil)
    @user = user
    @cart = FindCartForUser.new(user).find || new_cart(currency)
    CartCurrencyUpdater.new(@cart).update(currency)
  end

  def add_product_to_cart(product, quantity=1)
    AddProductToCart.new(@cart).add(product, quantity)
  end

  # when a user makes a change to all quantities at once then clicks 'save'
  def update_items_in_cart(line_item_quantities)
    UpdateItemsInCart.new(@cart).add(line_item_quantities)
  end

  def remove_product_from_cart(product)
    RemoveProductFromCart.new(@cart).remove(product)
  end

  def empty_cart
    EmptyCart.new(@cart).empty
  end

  def items_in_cart
    #?
  end

  private
    def new_cart(currency)
      cart_source.call(user: @user, currency: currency)
    end

    def cart_source
      @cart_source ||= Cart.public_method(:new)
    end
end

class ProductPriceForCurrency
  def initialize(product)
    @product = product
  end

  def find(currency)
    @product.price_in_currency(currency)
  end
end

class CartCurrencyUpdater
  def initialize(cart)
    @cart = cart
  end

  def update(currency)
    @cart.update_currency(currency)
  end
end

class FindCartForUser
  def initialize(cart)
    @cart = cart
  end

  def find
    nil # TODO
  end
end

class UpdateItemsInCart
  def initialize(cart)
    @cart = cart
  end

  def update_items(line_item_quantities)
    @cart.update_items(line_item_quantities)
  end
end

class EmptyCart
  def initialize(cart)
    @cart = cart
  end

  def empty
    @cart.empty
  end
end

class AddProductToCart
  def initialize(cart)
    @cart = cart
  end

  def add(product, quantity=1)
    @cart.add_product(product,quantity)
  end
end

class RemoveProductFromCart
  def initialize(cart)
    @cart = cart
  end

  def remove(product)
    finder = FindItemInCart.new(@cart)
    line_item = finder.find(product)
    RemoveItemFromCart.new(@cart).remove(line_item)
  end
end

class RemoveItemFromCart
  def initialize(cart)
    @cart = cart
  end

  def remove(line_item)
    @cart.remove_item(line_item)
  end
end

class ChangeQuantityOfProductInCart
  def initialize(cart)
    @cart = cart
  end

  def change_quantity(product, quantity)
    finder = FindItemInCart.new(@cart)

    line_item = finder.find(product)
    line_item.change_quantity(quantity)
  end
end

class FindItemInCart
  def initialize(cart)
    @cart = cart
  end

  def find(product)
    @cart.matching_line_item(product) || NullLineItem.new
  end
end
