class CreditCard < ActiveRecord::Base
  has_many :payments, as: :source
  belongs_to :billing_address
  before_save :set_last_digits

  attr_accessor :number, :verification_value

  validates :month, :year, numericality: { only_integer: true }, on: :create
  validates :number, presence: true, on: :create
  validates :name_on_card, presence: true, on: :create
  validates :verification_value, presence: true, on: :create

  validate :expiry_not_in_the_past

  private
    def set_last_digits
      number.to_s.gsub!(/\s/,'')
      verification_value.to_s.gsub!(/\s/,'')
      self.last_digits ||= number.to_s.length <= 4 ? number : number.to_s.slice(-4..-1)
    end

    def expiry_not_in_the_past
      if year.present? && month.present?
        if month.to_i < 1 || month.to_i > 12
          errors.add(:base, :expiry_invalid)
        else
          current = Time.current
          if year.to_i < current.year || (year.to_i == current.year && month.to_i < current.month)
            errors.add(:base, :card_expired)
          end
        end
      end
    end
end
