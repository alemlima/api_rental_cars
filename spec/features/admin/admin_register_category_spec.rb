require 'rails_helper'

feature 'Admin register category' do
  scenario 'sucessfully' do
    user = create(:user, role: :admin)

    login_as user, scope: :user

    visit root_path
    click_on 'Categorias'
    click_on 'Nova Categoria'

    fill_in 'Nome', with: 'A'
    fill_in 'Diária padrão', with: 50
    fill_in 'Seguro padrão do carro', with: 100
    fill_in 'Seguro padrão contra terceiros', with: 120

    click_on 'Enviar'

  expect(page).to have_content('Categoria cadastrada com sucesso!')
  expect(page).to have_content('Nome: A')
  expect(page).to have_content('Diária padrão: R$ 50,00')
  expect(page).to have_content('Seguro padrão do carro: R$ 100,00')
  expect(page).to have_content('Seguro padrão contra terceiros: R$ 120,00')
  expect(page).to have_link('Voltar')

  end
end