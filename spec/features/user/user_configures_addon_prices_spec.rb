require 'rails_helper'

feature 'User configures addon prices' do
  scenario 'successfully' do
    subsidiary = create(:subsidiary, name: 'Almeida Automóveis')
    user = create(:user, role: :user, subsidiary: subsidiary)
    create(:addon, name: 'Bebê conforto', standard_daily_rate: 10.0)
    create(:addon, name: 'GPS', standard_daily_rate: 10.0)
    login_as user, scope: :user

    visit root_path
    click_on 'Preços de adicionais'
    click_on 'Editar valores'
    within('.addon_price1') do
      find(:css, '.daily_rate').set('54.25')
    end
    within('.addon_price2') do
      find(:css, '.daily_rate').set('44.25')
    end
    click_on 'Enviar'

    expect(page).to have_content('Bebê conforto')
    expect(page).to have_content('GPS')
    expect(page).to have_content('R$ 54,25')
    expect(page).to have_content('R$ 44,25')
    expect(page).not_to have_content('R$ 10,0')
    expect(page).not_to have_content('R$ 20,0')
  end

  scenario 'and must fill all fields' do
    subsidiary = create(:subsidiary, name: 'Almeida Automóveis')
    user = create(:user, role: :user, subsidiary: subsidiary)
    create(:addon, name: 'Bebê conforto', standard_daily_rate: 10.0)
    create(:addon, name: 'GPS', standard_daily_rate: 10.0)
    login_as user, scope: :user

    visit root_path
    click_on 'Preços de adicionais'
    click_on 'Editar valores'
    within('.addon_price1') do
      find(:css, '.daily_rate').set('')
    end
    within('.addon_price2') do
      find(:css, '.daily_rate').set('')
    end
    click_on 'Enviar'

    expect(page).to have_content('Diária não pode ficar em branco')
  end

  scenario 'and can view only same subsidiary prices' do
    subsidiary = create(:subsidiary, name: 'Almeida Automóveis')
    other_subsidiary = create(:subsidiary, name: 'Morato Motors')
    user = create(:user, role: :user, subsidiary: subsidiary)
    addon_bebe = create(:addon, name: 'Bebê conforto',
                                standard_daily_rate: 10.0)
    addon_gps = create(:addon, name: 'GPS',
                               standard_daily_rate: 10.0)
    create(:addon_price, addon: addon_bebe, daily_rate: 15.0,
                         subsidiary: other_subsidiary)
    create(:addon_price, addon: addon_gps, daily_rate: 35.0,
                         subsidiary: other_subsidiary)
    login_as user, scope: :user

    visit root_path
    click_on 'Preços de adicionais'
    click_on 'Editar valores'
    within('.addon_price1') do
      find(:css, '.daily_rate').set('54.25')
    end
    within('.addon_price2') do
      find(:css, '.daily_rate').set('44.25')
    end
    click_on 'Enviar'

    expect(page).to have_content('Bebê conforto')
    expect(page).to have_content('R$ 54,25')
    expect(page).to have_content('GPS')
    expect(page).to have_content('R$ 44,25')
    expect(page).not_to have_content('R$ 15,0')
    expect(page).not_to have_content('R$ 35,0')
    expect(page).not_to have_content('R$ 10,0')
    expect(page).not_to have_content('R$ 20,0')
  end
end
