FactoryBot.define do
  factory :car do
    car_model
    color { 'Dourado' }
    sequence(:license_plate) { |n| "CCC-000#{n}" }
    car_km { 100 }
    status { :available }
    subsidiary
  end
end
