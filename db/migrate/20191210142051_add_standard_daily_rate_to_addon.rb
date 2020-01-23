class AddStandardDailyRateToAddon < ActiveRecord::Migration[5.2]
  def change
    add_column :addons, :standard_daily_rate, :float
  end
end
