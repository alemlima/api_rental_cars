FactoryBot.define do
  factory :rental do
    start_date { '2019-11-13' }
    end_date { '2019-11-13' }
    client
    category
    subsidiary
    status { 0 }

    trait :with_car do
      transient do
        car { create(:car) }
      end

      after(:create) do |rental, evaluator|
        create(:rental_item, rental: rental, rentable: evaluator.car,
                             daily_rate: evaluator.car.category.daily_rate +
                             evaluator.car.category.car_insurance +
                             evaluator.car.category.third_party_insurance)
      end
    end

    trait :without_callbacks do
      after(:build) do |rental|
        rental.class.skip_callback(:create, :generate_reservation_code)
      end

      after(:create) do |rental|
        rental.class.set_callback(:create, :generate_reservation_code)
      end
    end
  end
end
