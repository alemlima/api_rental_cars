require 'rails_helper'

feature 'User edits car' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary, name: 'Almeidinha Automóveis')
    user = create(:user, role: :user, subsidiary: subsidiary)
    fiat = create(:manufacture, name: 'Fiat')
    gasolina = create(:fuel_type, name: 'Gasolina')
    category = create(:category, name: 'A')
    car_model = create(:car_model, name: 'Sport', manufacture: fiat,
                                   fuel_type: gasolina, category: category)
    create(:car_model, name: 'Sedan', manufacture: fiat, fuel_type: gasolina,
                       category: category)
    create(:car, car_model: car_model, license_plate: 'TTT-9898',
                 subsidiary: subsidiary)
    login_as user, scope: :user
    visit root_path

    click_on 'Carros'
    click_on 'TTT-9898'
    click_on 'Editar carro'
    select 'Sedan', from: 'Modelo'
    fill_in 'Quilometragem', with: '120'
    fill_in 'Cor', with: 'Prata'
    fill_in 'Placa', with: 'HPL-6666'
    click_on 'Enviar'

    expect(page).to have_content('Modelo')
    expect(page).to have_content('Sedan')
    expect(page).to have_content('Quilometragem')
    expect(page).to have_content('120')
    expect(page).to have_content('Cor')
    expect(page).to have_content('Prata')
    expect(page).to have_content('Placa')
    expect(page).to have_content('HPL-6666')
  end

  scenario 'and must fill all fields' do
    subsidiary = create(:subsidiary, name: 'Almeidinha Automóveis')
    user = create(:user, role: :user, subsidiary: subsidiary)
    fiat = create(:manufacture, name: 'Fiat')
    gasolina = create(:fuel_type, name: 'Gasolina')
    category = create(:category, name: 'A')
    car_model = create(:car_model, name: 'Sport', manufacture: fiat,
                                   fuel_type: gasolina, category: category)
    create(:car_model, name: 'Sedan', manufacture: fiat, fuel_type: gasolina,
                       category: category)
    create(:car, car_model: car_model, license_plate: 'TTT-9898',
                 subsidiary: subsidiary)
    login_as user, scope: :user
    visit root_path

    click_on 'Carros'
    click_on 'TTT-9898'
    click_on 'Editar carro'
    fill_in 'Quilometragem', with: ''
    fill_in 'Cor', with: ''
    fill_in 'Placa', with: ''
    click_on 'Enviar'

    expect(page).to have_content('Quilometragem não pode ficar em branco')
    expect(page).to have_content('Cor não pode ficar em branco')
    expect(page).to have_content('Placa não pode ficar em branco')
  end

  scenario 'and must be user from same subsidiary as the car' do
    subsidiary = create(:subsidiary, name: 'Almeidinha Automóveis')
    other_subsidiary = create(:subsidiary, name: 'Morato Motors')
    user = create(:user, role: :user, subsidiary: subsidiary)
    fiat = create(:manufacture, name: 'Fiat')
    gasolina = create(:fuel_type, name: 'Gasolina')
    category = create(:category, name: 'A')
    car_model = create(:car_model, name: 'Sport', manufacture: fiat,
                                   fuel_type: gasolina, category: category)
    create(:car_model, name: 'Sedan', manufacture: fiat, fuel_type: gasolina,
                       category: category)
    car = create(:car, car_model: car_model, license_plate: 'TTT-9898',
                       subsidiary: other_subsidiary)
    login_as user, scope: :user
    visit edit_car_path(car.id)

    expect(current_path).to eq cars_path
  end

  scenario 'and must not be admin to see button' do
    user = create(:user, role: :admin)
    fiat = create(:manufacture, name: 'Fiat')
    gasolina = create(:fuel_type, name: 'Gasolina')
    categoria = create(:category, name: 'A')
    create(:car_model, name: 'Sport', manufacture: fiat, fuel_type: gasolina,
                       category: categoria)

    login_as user, scope: :user
    visit root_path

    expect(page).not_to have_link('Carros')
  end

  scenario 'and must be logged in' do
    visit root_path

    expect(page).not_to have_content('Carros')
  end

  scenario 'and visitor can not edit via url' do
    subsidiary = create(:subsidiary, name: 'Almeidinha Automóveis')
    user = create(:user, role: :user, subsidiary: subsidiary)
    fiat = create(:manufacture, name: 'Fiat')
    gasolina = create(:fuel_type, name: 'Gasolina')
    category = create(:category, name: 'A')
    car_model = create(:car_model, name: 'Sport', manufacture: fiat,
                                   fuel_type: gasolina, category: category)
    create(:car_model, name: 'Sedan', manufacture: fiat, fuel_type: gasolina,
                       category: category)
    car = create(:car, car_model: car_model, license_plate: 'TTT-9898',
                       subsidiary: subsidiary)
    visit edit_car_path(car.id)

    expect(current_path).to eq new_user_session_path
  end
end
