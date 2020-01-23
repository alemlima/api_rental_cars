require 'rails_helper'

feature 'User finalizes rental' do
  xscenario 'successfully searches for rental' do
    subsidiary = create(:subsidiary, name: 'Almeida Motors')
    category = create(:category, name: 'Deluxe', daily_rate: 10,
                                 car_insurance: 10,
                                 third_party_insurance: 10)
    car_model = create(:car_model, category: category)
    car = create(:car, car_model: car_model, status: :available,
                       subsidiary: subsidiary)
    user = create(:user, role: :user, subsidiary: subsidiary)
    rental = create(:rental, :with_car, start_date: '3000-01-01',
                                        end_date: '3000-01-05',
                                        status: :ongoing, category: category,
                                        subsidiary: subsidiary, car: car)
    login_as user, scope: :user

    visit root_path
    click_on 'Locações'
    fill_in 'Código da reserva', with: rental.reservation_code
    click_on 'Buscar'

    expect(page).to have_content(rental.reservation_code)
    expect(page).to have_content('Data de início: 01 de janeiro de 3000')
    expect(page).to have_content('Data de término: 05 de janeiro de 3000')
    expect(page).to have_content("Categoria: #{rental.category.name}")
    expect(page).to have_content("Locação de: #{rental.client.name}")
    expect(page).to have_content('R$ 120,00')
    expect(rental.reload).to be_ongoing
    expect(page).to have_content('Encerrar locação')
  end
end
