address = Address.new(street: 'R. do Barril', number: '1', complement: '3',
                         neighborhood: 'Vila do Chavez', city: 'Guarujá',
                         state: 'São Paulo')
other_address = Address.new(street: 'R. Formosa', number: '12',
                               complement: '3', neighborhood: 'Vila da Glória',
                               city: 'São Paulo', state: 'São Paulo')
client_address_a = Address.new(street: 'R. Céu', number: '666', complement: '3',
                             neighborhood: 'Vilinha',
                             city: 'Guarulhos', state: 'São Paulo')
client_address_b = Address.new(street: 'R. Purpurina', number: '36', complement: '3',
                             neighborhood: 'Mada',
                             city: 'São Paulo', state: 'São Paulo')
client_address_c = Address.new(street: 'R. Caracol', number: '6', complement: '5',
                             neighborhood: 'Ipelandia',
                             city: 'Suzano', state: 'São Paulo')
client_address_d = Address.new(street: 'R. Guaribe', number: '76', complement: '3',
                             neighborhood: 'Solupe',
                             city: 'Jaca', state: 'Onde')
client_address_e = Address.new(street: 'R. Tocotoco', number: '32', complement: '8',
                             neighborhood: 'Jardim Pedra',
                             city: 'Avemaria', state: 'Minas Gerais')
client_address_f = Address.new(street: 'R. Paulo Velho', number: '23', complement: 'sem complemento',
                             neighborhood: 'Joana Darc',
                             city: 'Jandira', state: 'São Paulo')
client_address_g = Address.new(street: 'R. Pedreira', number: '2', complement: 'sem complemento',
                             neighborhood: 'Apolonio',
                             city: 'São Carlos', state: 'São Paulo')

subsidiary = Subsidiary.create(name: 'Almeidinha Automóveis',
                               cnpj: '57.669.960/0001-66',
                               address: address)
other_subsidiary = Subsidiary.create(name: 'Morato Motors',
                                     cnpj: '56.633.230/0001-33',
                                     address: other_address)

Client.create(name: 'Claudionor', cpf: '318.421.176-43',
              type: 'IndividualClient',
              email:'cro@email.com', address: client_address_a)
Client.create(name: 'Érico', cpf: '640.290.360-40', type: 'IndividualClient',
              email: 'erico@email.com', address: client_address_b)
Client.create(name: 'Jonatas', cpf: '724.602.690-80', type: 'IndividualClient',
              email: 'jonatas@email.com', address: client_address_c)
Client.create(name: 'Vini', cpf: '200.638.590-92', type: 'IndividualClient',
              email: 'Vini@email.com', address: client_address_d)
Client.create(trade_name: 'Renner', cnpj: '86.288.761/0001-06',
              email: 'Renner@email.com', address: client_address_e,
              type: 'CorporateClient')
Client.create(trade_name: 'Havaianas', cnpj: '12.155.270/0001-50',
              email: 'havaianas@email.com', address: client_address_f,
              type: 'CorporateClient')
Client.create(trade_name: 'Kalunga', cnpj: '47.557.816/0001-84',
              email: 'kalunga@email.com', address: client_address_g,
              type: 'CorporateClient')

User.create(email: 'user@email.com', password: '123456', subsidiary: subsidiary,
            role: :user)
User.create(email: 'user1@email.com', password: '123456',
            subsidiary: other_subsidiary, role: :user)
User.create(email: 'admin@email.com', password: '123456', role: :admin)

category_a = Category.create(name: 'A', daily_rate: 50.0, car_insurance: 50.0,
           third_party_insurance: 50.0)
category_b = Category.create(name: 'B', daily_rate: 50.0, car_insurance: 50.0,
           third_party_insurance: 50.0)
category_c = Category.create(name: 'C', daily_rate: 50.0, car_insurance: 50.0,
           third_party_insurance: 50.0)

RentalPrice.create(category: category_a, subsidiary: subsidiary,
                   daily_rate: 66.0, daily_car_insurance: 55.0,
                   daily_third_party_insurance: 63.0)
RentalPrice.create(category: category_b, subsidiary: subsidiary,
                   daily_rate: 44.0, daily_car_insurance: 53.0,
                   daily_third_party_insurance: 34.0)
RentalPrice.create(category: category_c, subsidiary: subsidiary,
                   daily_rate: 36.0, daily_car_insurance: 23.0,
                   daily_third_party_insurance: 23.0)

RentalPrice.create(category: category_a, subsidiary: other_subsidiary,
                   daily_rate: 62.0, daily_car_insurance: 61.0,
                   daily_third_party_insurance: 64.0)
RentalPrice.create(category: category_b, subsidiary: other_subsidiary,
                   daily_rate: 39.0, daily_car_insurance: 53.0,
                   daily_third_party_insurance: 24.0)
RentalPrice.create(category: category_c, subsidiary: other_subsidiary,
                   daily_rate: 33.0, daily_car_insurance: 22.0,
                   daily_third_party_insurance: 23.0)

addon_gps = Addon.create(name: 'GPS', description: 'Aparelho de GPS Garmin',
                         standard_daily_rate: 10.0)
addon_bebe = Addon.create(name: 'Bebê conforto',
                          description: 'Bebê conforto Cosco',
                          standard_daily_rate: 20.0)
addon_copo = Addon.create(name: 'Porta copos',
                          description: 'Suporte para copos',
                          standard_daily_rate: 5.0)

addon_gps.photo.attach(io: File.open(Rails.root.join('public', 'gps.jpg')), filename: 'gps.jpg')
addon_bebe.photo.attach(io: File.open(Rails.root.join('public', 'bebe_conforto.jpg')), filename: 'bebe_conforto.jpg')
addon_copo.photo.attach(io: File.open(Rails.root.join('public', 'porta_copos.jpg')), filename: 'porta_copos.jpg')

AddonItem.create(addon: addon_gps, registration_number: '123456',
                 status: :available)
AddonItem.create(addon: addon_gps, registration_number: '789010',
                 status: :available)
AddonItem.create(addon: addon_gps, registration_number: '828283',
                 status: :unavailable)
AddonItem.create(addon: addon_bebe, registration_number: '1234AR',
                 status: :available)
AddonItem.create(addon: addon_bebe, registration_number: '789010',
                 status: :available)
AddonItem.create(addon: addon_bebe, registration_number: '876532',
                 status: :unavailable)
AddonItem.create(addon: addon_copo, registration_number: '97429E',
                 status: :available)
AddonItem.create(addon: addon_copo, registration_number: '158TTE',
                 status: :available)

fiat = Manufacture.create(name: 'Fiat')
ford = Manufacture.create(name: 'Ford')
toyota = Manufacture.create(name: 'Toyota')
honda = Manufacture.create(name: 'Honda')
hyundai = Manufacture.create(name: 'Hyundai')
volkswagen = Manufacture.create(name: 'Wolkswagen')
bmw = Manufacture.create(name: 'BMW')

gasolina = FuelType.create(name: 'Gasolina')
alcool = FuelType.create(name: 'Álcool')
flex = FuelType.create(name: 'Flex')
diesel = FuelType.create(name: 'Dielsel')

uno = CarModel.create(name: 'Uno', year: 2019, manufacture: fiat,
                      motorization: '1.0', fuel_type: gasolina,
                      category: category_c, car_options: 'Ar condicionado')
gol = CarModel.create(name: 'Gol', year: 2019, manufacture: volkswagen,
                      motorization: '1.2', fuel_type: gasolina,
                      category: category_c, car_options: 'Ar condicionado')
palio = CarModel.create(name: 'Palio', year: 2019, manufacture: fiat,
                        motorization: '1.0', fuel_type: gasolina,
                        category: category_c, car_options: 'Ar condicionado')
fox = CarModel.create(name: 'Fox', year: 2019, manufacture: volkswagen,
                      motorization: '1.6', fuel_type: gasolina,
                      category: category_c, car_options: 'Ar condicionado')
hb = CarModel.create(name: 'HB20', year: 2019, manufacture: hyundai,
                     motorization: '2.0', fuel_type: flex,
                     category: category_b, car_options: 'Ar condicionado')
ka = CarModel.create(name: 'Ka', year: 2019, manufacture: ford,
                     motorization: '1.0', fuel_type: gasolina,
                     category: category_c, car_options: 'Ar condicionado')
corolla = CarModel.create(name: 'Corolla', year: 2019, manufacture: toyota,
                          motorization: '2.0', fuel_type: gasolina,
                          category: category_b, car_options: 'Ar condicionado')
civic = CarModel.create(name: 'Civic', year: 2019, manufacture: honda,
                        motorization: '2.0', fuel_type: flex,
                        category: category_b, car_options: 'Ar condicionado')
bmw = CarModel.create(name: 'BMW X5', year: 2019, manufacture: bmw,
                      motorization: '3.0', fuel_type: diesel,
                      category: category_a, car_options: 'Ar condicionado')

uno.photo.attach(io: File.open(Rails.root.join('public', 'uno.jpg')), filename: 'uno.jpg')
gol.photo.attach(io: File.open(Rails.root.join('public', 'gol.jpg')), filename: 'gol.jpg')
palio.photo.attach(io: File.open(Rails.root.join('public', 'palio.png')), filename: 'palio.png')
fox.photo.attach(io: File.open(Rails.root.join('public', 'fox.jpg')), filename: 'fox.jpg')
hb.photo.attach(io: File.open(Rails.root.join('public', 'hb.jpg')), filename: 'hb.jpg')
ka.photo.attach(io: File.open(Rails.root.join('public', 'ka.jpeg')), filename: 'ka.jpeg')
corolla.photo.attach(io: File.open(Rails.root.join('public', 'corolla.jpg')), filename: 'corolla.jpg')
civic.photo.attach(io: File.open(Rails.root.join('public', 'civic.png')), filename: 'civic.png')
bmw.photo.attach(io: File.open(Rails.root.join('public', 'bmw.jpg')), filename: 'bmw.jpg')

Car.create(car_model: uno, color: 'Bege', license_plate: 'MWD-0617',
           status: :available, subsidiary: subsidiary, car_km: 22)
Car.create(car_model: uno, color: 'Verde', license_plate: 'HPN-4425',
           status: :available, subsidiary: subsidiary, car_km: 20)
Car.create(car_model: gol, color: 'Preto', license_plate: 'NEX-0316',
           status: :available, subsidiary: subsidiary, car_km: 52)
Car.create(car_model: palio, color: 'Vermelho', license_plate: 'HRQ-0837',
           status: :available, subsidiary: subsidiary, car_km: 626)
Car.create(car_model: fox, color: 'Bege', license_plate: 'KBE-1960',
           status: :available, subsidiary: subsidiary, car_km: 12)
Car.create(car_model: hb, color: 'Marfim', license_plate: 'KBE-1960',
           status: :available, subsidiary: subsidiary, car_km: 3)
Car.create(car_model: ka, color: 'Pérola', license_plate: 'BBQ-6204',
           status: :available, subsidiary: subsidiary, car_km: 55)
Car.create(car_model: corolla, color: 'Prata', license_plate: 'HZG-8751',
           status: :available, subsidiary: subsidiary, car_km: 666)
Car.create(car_model: civic, color: 'Preto', license_plate: 'KKG-6645',
           status: :available, subsidiary: other_subsidiary, car_km: 100)
Car.create(car_model: bmw, color: 'Azul', license_plate: 'LVV-3832',
           status: :available, subsidiary: other_subsidiary, car_km: 61)
Car.create(car_model: uno, color: 'Vinho', license_plate: 'NAL-8779',
           status: :available, subsidiary: other_subsidiary, car_km: 4)
Car.create(car_model: gol, color: 'Amarelo', license_plate: 'IUF-1156',
           status: :available, subsidiary: other_subsidiary, car_km: 12)
Car.create(car_model: civic, color: 'Cinza', license_plate: 'GSA-0974',
           status: :available, subsidiary: other_subsidiary, car_km: 888)
Car.create(car_model: corolla, color: 'Branco', license_plate: 'NEZ-3710',
           status: :available, subsidiary: other_subsidiary, car_km: 123)
Car.create(car_model: gol, color: 'Azul', license_plate: 'BZH-7108',
           status: :available, subsidiary: other_subsidiary, car_km: 65)
Car.create(car_model: bmw, color: 'Prata', license_plate: 'JUN-7638',
           status: :available, subsidiary: other_subsidiary, car_km: 10)
