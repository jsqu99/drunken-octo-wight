class AddPayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :order, null: false
      t.references :source, :polymorphic => true
      t.monetize  :amount, null: false
      t.timestamps
    end

    create_table :credit_cards do |t|
      t.string     :name_on_card, null: false
      t.string     :month, null: false
      t.string     :year, null: false
      t.string     :last_digits, null: false, limit: 4
      t.references :billing_address, null: false
      t.string     :gateway_customer_profile_id
      t.string     :gateway_payment_profile_id
      t.timestamps
    end
  end
end
