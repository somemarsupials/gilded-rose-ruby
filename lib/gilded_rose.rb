require File.join(File.dirname(__FILE__), 'typed_item_factory')

class GildedRose
  attr_reader :items

  def initialize(items, factory = TypedItemFactory.new)
    @items = convert(items, factory)
  end

  def update
    @items.each { |item| item.update }
  end

  def convert(items, factory)
    items.map { |item| factory.generate(item) }
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
