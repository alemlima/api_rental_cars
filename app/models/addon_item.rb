class AddonItem < ApplicationRecord
  enum status: { available: 0, unavailable: 10 }
  belongs_to :addon

  def current_price(subsidiary)
    AddonPrice.where(subsidiary: subsidiary, addon: addon).last.daily_rate
  end
end
