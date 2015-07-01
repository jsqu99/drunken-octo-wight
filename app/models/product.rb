class Product < ActiveRecord::Base
  has_many :prices, class_name: "ProductPrice"

  def price_in_currency(currency)
    self.prices.detect {|p|
      p.price_currency == currency
    }.price rescue raise MissingCurrencyForProductError
  end
end
