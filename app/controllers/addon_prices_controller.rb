class AddonPricesController < ApplicationController
  def index
    @subsidiaries = Subsidiary.all
    @addon_prices = last_addon_prices
  end

  def new
    @addon_prices = {}
    @addons = Addon.all
    @addons.each do |addon|
      addon_price = AddonPrice.where(addon: addon,
                                     subsidiary: current_subsidiary).last
      @addon_prices[addon] = addon_price if addon_price
    end
  end

  def create
    params['addon_prices'].each do |_key, values|
      @addon_price = AddonPrice.new(addon_price_params(values))
      @addon_price.subsidiary = current_subsidiary
      next if @addon_price.save

      @addon_prices = {}
      @addons = Addon.all
      @addons.each do |addon|
        addon_price = AddonPrice.where(addon: addon,
                                       subsidiary: current_subsidiary).last
        @addon_prices[addon] = addon_price if addon_price
      end
      @messages = @addon_price.errors.full_messages
      return render :new
    end
    redirect_to addon_prices_path
  end

  private

  def addon_price_params(addon_params)
    addon_params.permit(:daily_rate, :addon_id)
  end

  def last_addon_prices
    AddonPrice.where(subsidiary: current_subsidiary).last(Addon.all.count)
  end
end
