class Rental < ApplicationRecord
  before_create :generate_reservation_code
  enum status: { scheduled: 0, in_review: 5, ongoing: 10, finalized: 15 }
  has_many :rental_items
  belongs_to :client
  belongs_to :category
  belongs_to :subsidiary
  validates :start_date, :end_date, presence: true
  validate :price_cannot_be_zero, :rental_period_must_be_valid
  validate :cars_available, on: :create

  accepts_nested_attributes_for :rental_items

  def calculate_price_projection
    return 0 unless start_date && end_date && category

    days = (end_date - start_date).to_i
    value = category.daily_rate + category.car_insurance +
            category.third_party_insurance
    days * value
  end

  def rental_period_must_be_valid
    return 0 if start_date.nil? || end_date.nil?

    if start_date < Time.zone.now
      errors.add(:start_date, 'não pode estar no passado.')
    elsif start_date > end_date
      errors.add(:start_date, 'não pode ser maior que data de término.')
    end
  end

  def available_cars
    category.cars.where(status: :available, subsidiary: subsidiary)
  end

  def cars_available
    if cars_available_at_date_range
      errors.add(:category, 'Não há carros disponíveis na categoria escolhida.')
    end
  end

  def price_cannot_be_zero
    if calculate_price_projection <= 0
      errors.add(:base, 'Valor estimado não pode ser zero.')
    end
  end

  def car
    rental_items.find_by(rentable_type: 'Car').rentable
  end

  def user_authorized(user)
    return true if user.admin?

    subsidiary == user.subsidiary
  end

  private

  def cars_available_at_date_range
    scheduled_rentals = Rental.where(category: category)
                              .where(start_date: start_date..end_date)
                              .or(Rental.where(category: category)
      .where(end_date: start_date..end_date))

    available_cars_at_category = Car
                                 .where(status: :available,
                                        subsidiary: subsidiary)
                                 .joins(:car_model)
                                 .where(car_models: { category: category })
    scheduled_rentals.count >= available_cars_at_category.count
  end

  def generate_reservation_code
    self.reservation_code = loop do
      token = generate_random_token
      break token unless Rental.exists?(reservation_code: token)
    end
  end

  def generate_random_token
    charset = Array('A'..'Z') + Array(0..9)
    Array.new(6) { charset.sample }.join
  end
end
