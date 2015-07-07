class BillingAddress < ActiveRecord::Base
  validates :fake_string, presence: true
end
