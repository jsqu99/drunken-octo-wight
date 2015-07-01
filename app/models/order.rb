class Order < ActiveRecord::Base
  belongs_to :cart
  has_one :shipping_address #optional - if we only have subscription line items, each line item will have it's own shipping address
end
