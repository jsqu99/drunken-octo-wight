class CreateCartTables < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :product, null: false
      t.references :cart
      t.integer    :quantity, null: false
      t.monetize  :unit_price, null: false
      t.timestamps
    end

    create_table :product_prices do |t|
      t.references :product, index: true
      t.monetize :price #, null: false ?
    end

    create_table :orders do |t|
      t.references :cart, null: false
    end

    create_table :carts do |t|
      t.references :user
      t.references :order
      t.string :currency, null: false
      t.timestamps
    end
  end
end
