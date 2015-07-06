class AddOrderAdjustments < ActiveRecord::Migration
  def change
    create_table :order_adjustments do |t|
      t.references :order, null: false
      t.string :description, null: false
      t.monetize  :amount, null: false
      t.timestamps
    end
  end
end
