require 'rails_helper'

feature 'User register car' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary, name: 'Morato Motors')
    user = create(:user, role: :user, subsidiary: subsidiary)
    fiat = create(:manufacture, name: 'Fiat')
    gasolina = create(:fuel_type, name: 'Gasolina')
    categoria = create(:category, name: 'A')
    create(:car_model, name: 'Sport', manufacture: fiat, fuel_type: gasolina,
                       category: categoria)

    login_as user, scope: :user
    visit root_path

    click_on 'Carros'
    click_on 'Registrar novo carro'
    select 'Sport', from: 'Modelo'
    fill_in 'Quilometragem', with: '200'
    fill_in 'Cor', with: 'Verde Musgo'
    fill_in 'Placa', with: 'HPL6666'
    click_on 'Enviar'

    expect(page).to have_content('Modelo')
    expect(page).to have_content('Sport')
    expect(page).to have_content('Quilometragem')
    expect(page).to have_content('200')
    expect(page).to have_content('Cor')
    expect(page).to have_content('Verde Musgo')
    expect(page).to have_content('Placa')
    expect(page).to have_content('HPL6666')
    expect(page).to have_content('Fabricante')
    expect(page).to have_content('Fiat')
    expect(page).to have_content('Combustível')
    expect(page).to have_content('Gasolina')
  end

  scenario 'and must fill all fields' do
    user = create(:user, role: :user)

    login_as user, scope: :user
    visit root_path
    click_on 'Carros'
    click_on 'Registrar novo carro'
    click_on 'Enviar'

    expect(page).to have_content('Modelo é obrigatório')
    expect(page).to have_content('Quilometragem não pode ficar em branco')
    expect(page).to have_content('Cor não pode ficar em branco')
    expect(page).to have_content('Placa não pode ficar em branco')
  end

  scenario 'and license plate must be unique' do
    subsidiary = create(:subsidiary, name: 'Morato Motors')
    user = create(:user, role: :user, subsidiary: subsidiary)
    categoria = create(:category, name: 'A')
    car_model = create(:car_model, name: 'Sport', category: categoria)
    create(:car, license_plate: 'TTT-9999', car_model: car_model)

    login_as user, scope: :user
    visit root_path

    click_on 'Carros'
    click_on 'Registrar novo carro'
    select 'Sport', from: 'Modelo'
    fill_in 'Quilometragem', with: '200'
    fill_in 'Cor', with: 'Verde Musgo'
    fill_in 'Placa', with: 'TTT-9999'
    click_on 'Enviar'

    expect(page).to have_content('Placa já está em uso')
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

    expect(page).not_to have_link('Registrar novo carro')
  end

  scenario 'and must be logged in' do
    visit root_path

    expect(page).not_to have_content('Carros')
  end

  scenario 'and visitor can not register via url' do
    visit new_car_path

    expect(current_path).to eq new_user_session_path
  end
end
