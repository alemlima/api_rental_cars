class RemovePriceProjectionFromRental < ActiveRecord::Migration[5.2]
  def change
    remove_column :rentals, :price_projection, :string
  end
end
