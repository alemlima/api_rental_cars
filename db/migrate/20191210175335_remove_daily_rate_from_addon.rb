class RemoveDailyRateFromAddon < ActiveRecord::Migration[5.2]
  def change
    remove_column :addons, :daily_rate, :float
  end
end
