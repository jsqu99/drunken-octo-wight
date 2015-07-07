class AddInvoiceAdjustments < ActiveRecord::Migration
  def change
    create_table :invoice_adjustments do |t|
      t.references :invoice, null: false
      t.string :type, null: false
      t.string :description, null: false
      t.monetize  :amount, null: false
      t.timestamps
    end
  end
end
