class Addon < ApplicationRecord
  has_one_attached :photo
  has_many :addon_items
  validates :name, :standard_daily_rate, :description, presence: true
  after_save :generate_addon_price

  def generate_addon_price
    subsidiaries = Subsidiary.all
    return unless subsidiaries.any?

    subsidiaries.each do |subsidiary|
      AddonPrice.create(addon: self, subsidiary: subsidiary,
                        daily_rate: standard_daily_rate)
    end
  end

  def first_available_item
    addon_items.find_by(status: :available)
  end
end
