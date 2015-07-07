class CreateCartTables < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :product, null: false
      t.references :cart, index: true
      t.integer    :quantity, null: false
      t.monetize  :unit_price, null: false
      t.timestamps
    end

    create_table :product_prices do |t|
      t.references :product, index: true
      t.monetize :price, null: false
    end

    create_table :orders do |t|
      t.references :cart, index: true, null: false
    end

    create_table :invoices do |t|
      t.references :order, index: true, null: false
      t.monetize :total
    end

    create_table :carts do |t|
      t.references :user, index: true
      t.string :currency, null: false
      t.timestamps
    end
  end
end
