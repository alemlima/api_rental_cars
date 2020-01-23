require 'rails_helper'

describe 'Rentals', type: :request do
  it 'should redirect to rental when starting rental not in_review' do
    subsidiary = create(:subsidiary, name: 'Almeidinha Automóveis')
    other_subsidiary = create(:subsidiary, name: 'MoratoMotors')
    user = create(:user, subsidiary: subsidiary)
    category = create(:category, name: 'A', daily_rate: 10, car_insurance: 20,
                                 third_party_insurance: 20)
    customer = create(:individual_client, name: 'Claudionor',
                                          cpf: '318.421.176-43',
                                          email: 'cro@email.com')
    car_model = create(:car_model, name: 'Sedan', category: category)
    user = create(:user, role: :user, subsidiary: subsidiary)
    create(:car, car_model: car_model, license_plate: 'TTT-9898',
                 subsidiary: other_subsidiary)
    rental = create(:rental, category: category,
                             subsidiary: other_subsidiary,
                             start_date: '3000-01-08', end_date: '3000-01-10',
                             client: customer, status: :scheduled)
    login_as user, scope: :user

    post start_rental_path(rental)

    expect(response).to redirect_to(rental_path(rental))
    expect(rental.scheduled?).to eq true
  end

  it 'should redirect to rental unless user from same subsidiary' do
    subsidiary = create(:subsidiary, name: 'Almeidinha Automóveis')
    other_subsidiary = create(:subsidiary, name: 'MoratoMotors')
    user = create(:user, subsidiary: subsidiary)
    category = create(:category, name: 'A', daily_rate: 10, car_insurance: 20,
                                 third_party_insurance: 20)
    customer = create(:individual_client, name: 'Claudionor',
                                          cpf: '318.421.176-43',
                                          email: 'cro@email.com')
    car_model = create(:car_model, name: 'Sedan', category: category)
    user = create(:user, role: :user, subsidiary: subsidiary)
    create(:car, car_model: car_model, license_plate: 'TTT-9898',
                 subsidiary: other_subsidiary)
    rental = create(:rental, category: category, subsidiary: other_subsidiary,
                             start_date: '3000-01-08', end_date: '3000-01-10',
                             client: customer, status: :scheduled)
    login_as user, scope: :user

    post confirm_rental_path(rental)

    expect(response).to redirect_to(rental_path(rental))
  end

  it 'should redirect to rental when confirming not in_review rental' do
    subsidiary = create(:subsidiary, name: 'Almeidinha Automóveis')
    user = create(:user, subsidiary: subsidiary)
    category = create(:category, name: 'A', daily_rate: 10, car_insurance: 20,
                                 third_party_insurance: 20)
    customer = create(:individual_client, name: 'Claudionor',
                                          cpf: '318.421.176-43',
                                          email: 'cro@email.com')
    car_model = create(:car_model, name: 'Sedan', category: category)
    user = create(:user, role: :user, subsidiary: subsidiary)
    create(:car, car_model: car_model, license_plate: 'TTT-9898',
                 subsidiary: subsidiary)
    rental = create(:rental, category: category, subsidiary: subsidiary,
                             start_date: '3000-01-08', end_date: '3000-01-10',
                             client: customer, status: :scheduled)
    login_as user, scope: :user

    post confirm_rental_path(rental)

    expect(response).to redirect_to(rental_path(rental))
  end
  
  it 'should redirect to show when in closure review not ongoing rental' do
    subsidiary = create(:subsidiary, name: 'Almeidinha Automóveis')
    other_subsidiary = create(:subsidiary, name: 'MoratoMotors')
    user = create(:user, subsidiary: subsidiary)
    category = create(:category, name: 'A', daily_rate: 10, car_insurance: 20,
                                 third_party_insurance: 20)
    customer = create(:individual_client, name: 'Claudionor',
                                          cpf: '318.421.176-43',
                                          email: 'cro@email.com')
    car_model = create(:car_model, name: 'Sedan', category: category)
    user = create(:user, role: :user, subsidiary: subsidiary)
    create(:car, car_model: car_model, license_plate: 'TTT-9898',
                 subsidiary: other_subsidiary)
    rental = create(:rental, category: category, subsidiary: other_subsidiary,
                             start_date: '3000-01-08', end_date: '3000-01-10',
                             client: customer, status: :scheduled)
    login_as user, scope: :user

    get closure_review_rental_path(rental)

    expect(response).to redirect_to(rental_path(rental))
  end
end
