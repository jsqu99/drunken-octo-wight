require_relative 'line_item'

class Order
  attr_reader :line_items
  attr_writer :line_item_source

  def initialize
    @line_items = []
  end

  def add_to_cart(line_item)
    @line_items << line_item
  end

  def new_line_item
    line_item_source.call.tap do |p|
      p.order = self
    end
  end

  private
    def line_item_source
      @line_item_source ||= LineItem.public_method(:new)
    end
end
