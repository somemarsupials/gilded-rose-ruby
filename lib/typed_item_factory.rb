require File.join(File.dirname(__FILE__), 'default_item')
require File.join(File.dirname(__FILE__), 'special_item')

class TypedItemFactory
  attr_reader :item, :type

  PARAMS = {
    sell_in_incr: -1,
    quality_incr: -1,
    expiry_mul: 2,
    quality_max: 50,
    expiry: 0,
  }

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
    identify(item.name).new(item, params = PARAMS)
  end

  def identify(name, default = DefaultItem)
    @types.each { |regex, type| return type if regex.match(name.downcase) }
    default
  end
end
