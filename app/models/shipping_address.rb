class ShippingAddress < ActiveRecord::Base
  validates :fake_string, presence: true
  has_many :line_item_customizations, as: :customizable
end
