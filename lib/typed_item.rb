class TypedItem
  attr_reader :item, :type

  TYPES = {
    /aged brie/ => :aged_brie,
    /sulfuras/ => :legendary,
    /backstage_passes/ => :backstage_passes,
    /conjured/ => :conjured,
  }

  def initialize(item)
    @item = item
    @type = identify(item.name)
  end

  def identify(name)
    TYPES.each { |regex, type| return type if regex.match(name.downcase) }
    :default
  end
end
