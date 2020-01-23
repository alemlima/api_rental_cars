class AddonPrice < ApplicationRecord
  belongs_to :subsidiary
  belongs_to :addon
  validates :daily_rate, presence: true
end
