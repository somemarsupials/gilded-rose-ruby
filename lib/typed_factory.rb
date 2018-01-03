require File.join(File.dirname(__FILE__), 'default_item')
require File.join(File.dirname(__FILE__), 'special_item')

class TypedItemFactory
  attr_reader :item, :type

  TYPES = {
    /aged brie/ => AgedBrieItem,
    /sulfuras/ => LegendaryItem,
    /backstage_passes/ => BackstagePassesItem,
    /conjured/ => ConjuredItem,
  }

  def initialize(types = TYPES)
    @types = types
  end

  def generate(item)
    identify(item.name).new(item)
  end

  def identify(name, default = DefaultItem)
    @types.each { |regex, type| return type if regex.match(name.downcase) }
    default
  end
end
