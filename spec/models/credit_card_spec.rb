require 'money'
require 'spec_helper'

describe CreditCard do
  before do
    @credit_card = CreditCard.new(month: '1', year: '2016',
                                  number: '4111222233334444',
                                  name_on_card: 'Jacko Lantern',
                                  verification_value: '123',
                                  billing_address_id: 1)
  end

  it "does not store the full number" do
    @credit_card.save!
    expect(CreditCard.find(@credit_card.id).number).to be_nil
  end

  it "sets the last 4 digits" do
    @credit_card.save!
    expect(@credit_card.reload.last_digits).to eq('4444')
  end

  it "validates expiry not in the past" do
    @credit_card.year = '2015'
    @credit_card.save
    expect(@credit_card.errors[:base]).to include(I18n.translate(
      'activerecord.errors.models.credit_card.attributes.base.card_expired'
    ))
  end

  it "validates expiry month >=1 " do
    @credit_card.month = 0
    @credit_card.save
    expect(@credit_card.errors[:base]).to include(I18n.translate(
      'activerecord.errors.models.credit_card.attributes.base.expiry_invalid'
    ))
  end

  it "validates expiry month <= 12 " do
    @credit_card.month = 13
    @credit_card.save
    expect(@credit_card.errors[:base]).to include(I18n.translate(
      'activerecord.errors.models.credit_card.attributes.base.expiry_invalid'
    ))
  end

end
