class CreateLineItemCustomizations < ActiveRecord::Migration
  def change
    create_table :line_item_customizations do |t|
      t.references :line_item
      # t.string :simple_customization, null: true # for customizations that are simple strings e.g. engraving, gift message, etc.
      t.integer :customizable_id, null: false # null could be 'true' here if/when we implement :simple_customization
      t.string :customizable_type, null: false
      t.timestamps
    end

    # I need tables with these names for testing.
    # These will be replaced by lootcrate repo's version
    create_table :shipping_addresses do |t|
      t.string   :fake_string, null: false
    end

    create_table :billing_address do |t|
      t.string   :fake_string, null: false
    end

=begin
# these don't belong here.  Move
    create_table :shirt_sizes do |t|
      t.string :size, null: false
    end

    create_table :shoe_sizes do |t|
      t.string :size, null: false
    end

    create_table :bra_sizes do |t|
      t.string :size, null: false
    end
=end
  end
end
