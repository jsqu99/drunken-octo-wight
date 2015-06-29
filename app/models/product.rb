class Product < ActiveRecord::Base
  has_many :prices, class_name: "ProductPrice"
  has_many :plans

  def sold_out?
    plans.joins(:subscriptions).count("subscriptions") >= max_inventory_count
  end

  def price_in_currency(currency)
    self.prices.detect {|p|
      p.price_currency == currency
    }.price rescue raise MissingCurrencyForProductError
  end
end
