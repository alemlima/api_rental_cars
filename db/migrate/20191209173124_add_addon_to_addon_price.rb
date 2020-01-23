class AddAddonToAddonPrice < ActiveRecord::Migration[5.2]
  def change
    add_reference :addon_prices, :addon, foreign_key: true
  end
end
