class DefaultItem
  attr_reader :item, :params

  PARAMS = {
    sell_in_incr: -1,
    quality_incr: -1,
    expiry_mul: 2,
    quality_max: 50,
    expiry: 0,
  }

  def initialize(item, params = PARAMS)
    @item = item
    @params = params
  end

  def update
    update_sell_in
    update_quality
  end

  def update_sell_in
    alter_sell_in(@params[:sell_in_incr])
  end

  def update_quality
    alter_quality(quality_change)
  end

  private

  def alter_sell_in(value)
    @item.sell_in += value
  end

  def sell_in
    @item.sell_in
  end

  def alter_quality(value)
    @item.quality = [quality + value, @params[:quality_max]].min
  end

  def quality
    @item.quality
  end

  def quality_change
    @params[:quality_incr] * expiry_multiplier
  end

  def expiry_multiplier
    expired? ? @params[:expiry_mul] : 1
  end

  def expired?
    sell_in < @params[:expiry]
  end
end
