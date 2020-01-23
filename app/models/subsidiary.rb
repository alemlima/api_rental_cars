class Subsidiary < ApplicationRecord
  has_many :rental_prices
  has_many :addon_prices
  has_many :cars
  has_one :address, as: :addressable
  accepts_nested_attributes_for :address
  validates :name, presence: true
  validates :cnpj, presence: true
  after_save :generate_addon_prices

  def sub_rental_prices
    RentalPrice.where(subsidiary: self).last(Category.all.count)
  end

  def generate_addon_prices
    addons = Addon.all
    return unless addons.any?

    addons.each do |addon|
      AddonPrice.create!(subsidiary: self, addon: addon,
                         daily_rate: addon.standard_daily_rate)
    end
  end
end
