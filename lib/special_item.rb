require File.join(File.dirname(__FILE__), 'default_item')

# legendary items do not change in quality or sell-by!
class LegendaryItem < DefaultItem
  def initialize(item, params)
    super(item, params)
  end

  def update_sell_in
  end

  def update_quality
  end
end

# aged brie gets more valuable over time
class AgedBrieItem < DefaultItem
  def initialize(item, params, multiplier: -1)
    params = params.clone
    params[:quality_incr] *= multiplier
    super(item, params)
  end
end

# backstage passes change in value as the event approaches
# but they retain no value after the event
class BackstagePassesItem < DefaultItem
  def initialize(item, params, ten_or_less: 2, five_or_less: 3)
    params = params.clone
    params[:incr_5_or_less] = five_or_less
    params[:incr_10_or_less] = ten_or_less
    super(item, params)
  end

  private

  def quality_change
    return -quality if sell_in < 0
    case sell_in
    when 0..5
      @params[:incr_5_or_less]
    when 0..10
      @params[:incr_10_or_less]
    else
      @params[:quality_incr]
    end
  end
end

# conjured items decline twice as quickly
class ConjuredItem < DefaultItem
  def initialize(item, params, multiplier: 2)
    params = params.clone
    params[:quality_incr] *= multiplier
    super(item, params)
  end
end
