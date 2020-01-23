class AddAmountChargedToRental < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :amount_charged, :float
  end
end
