class CreateAddonPrices < ActiveRecord::Migration[5.2]
  def change
    create_table :addon_prices do |t|
      t.float :daily_rate
      t.references :subsidiary, foreign_key: true

      t.timestamps
    end
  end
end
