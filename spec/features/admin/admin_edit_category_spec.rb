require 'rails_helper'

feature 'Admin edit category' do
  scenario 'successfully' do
    category = create(:category, name: 'A',
                                 daily_rate: 50,
                                 car_insurance: 100,
                                 third_party_insurance: 120)
    user = create(:user, role: :admin)

    login_as user, scope: :user

    visit root_path
    click_on 'Categorias'
    click_on 'A'
    click_on 'Editar'

    fill_in 'Nome', with: 'B'
    fill_in 'Diária padrão', with: 60
    fill_in 'Seguro padrão do carro', with: 110 
    fill_in 'Seguro padrão contra terceiros', with: 130

    click_on 'Enviar'

    expect(page).to have_content('Categoria editada com sucesso!')
    expect(page).to have_content('Nome: B')
    expect(page).to have_content('Diária padrão: R$ 60,00')
    expect(page).to have_content('Seguro padrão do carro: R$ 110,00')
    expect(page).to have_content('Seguro padrão contra terceiros: R$ 130,00')
    expect(page).to have_link('Voltar')
  end
end